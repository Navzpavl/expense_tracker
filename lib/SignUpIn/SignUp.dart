import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/Controller/Auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String email;
  String password;
  String name;
  int val = 0;
  final formkey = GlobalKey<FormState>();
  FocusNode f1 = new FocusNode();
  FocusNode f2 = new FocusNode();
  FocusNode f3 = new FocusNode();
  FocusNode f4 = new FocusNode();
  bool profilePic=false;

  File _image;
  void _selectDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Profile Picture'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                          color: Colors.cyan,
                          icon: Icon(Icons.photo_library),
                          onPressed:(){
                            Navigator.pop(context);
                            _openGallary();
                          }
                      ),
                      Text("Gallery")
                    ],),
                  SizedBox(width: 5,),
                  Column(children: [
                    IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: (){
                          Navigator.pop(context);
                          _openCamera();
                        }
                    ),
                    Text("Camera")
                  ],),
                  SizedBox(width: 5,),
                  Column(children: [
                    IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.delete),
                        onPressed: (){
                          Navigator.pop(context);
                          _delete();
                        }
                    ),
                    Text("Delete")
                  ],)
                ],),
            ],
          );
        }
    );
  }



  Future<void>_openGallary() async{
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      _image=File(pickedFile.path);
    });
  }
  void _delete(){
    setState(() {
      _image=null;
      profilePic = false;
    });
  }
  Future<void>_openCamera() async{
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      _image=File(pickedFile.path);
    });
  }


  @override
  Widget build(BuildContext context){
    final ro = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff01608f),
        title: Text('Sign Up'),
        actions: [
          FlatButton.icon(onPressed:(){
            Navigator.pop(context);
            Navigator.pushNamed(context, '/w');
          },
            icon:Icon(Icons.person,
            color: Colors.white,),
            label: Text('Sign In',
              style: TextStyle(
              color: Colors.white
            ),),)
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/20,
            MediaQuery.of(context).size.height/100,
            MediaQuery.of(context).size.width/20, 0.0),
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              InkWell(
                onTap: (){
                  _selectDialog();
                  setState(() {
                    profilePic=true;
                  });
                },
                child: _image==null? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image,size: 150,color: Color(0xff01608f),),
                      Text('Select a profile picture',style: TextStyle(fontSize:20,)),
                    ])
              : ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.file(
                  _image,
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
              ),),
              SizedBox(height: MediaQuery.of(context).size.height/20,),
              TextFormField(
                focusNode: f1,
                decoration: InputDecoration(
                  labelText: 'Name',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.blue)
                  ),
                ),
                validator: RequiredValidator(errorText: "Name is required"),
                onChanged: (value) => name = value,
              ),
              SizedBox(height: MediaQuery.of(context).size.height/80,),
              TextFormField(
                focusNode: f2,
                decoration: InputDecoration(
                  labelText: 'Email',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.blue)
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Email is required"),
                  EmailValidator(errorText: "Enter a valid email address"),
                ]),
                onChanged: (value) => email = value,
              ),
              SizedBox(height: MediaQuery.of(context).size.height/80,),
              TextFormField(
                obscureText: true,
                focusNode: f3,
                decoration: InputDecoration(
                  labelText: 'Password',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.blue)
                  ),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Password is required"),
                  MinLengthValidator(6, errorText: "Password must have minimum 6 characters"),
                  PatternValidator(r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$', errorText: "Password must contain atleast one number and one letter")
                ]),
                onChanged: (value) => password = value,
              ),
              SizedBox(height: MediaQuery.of(context).size.height/80,),
              TextFormField(
                obscureText: true,
                focusNode: f4,
                decoration: InputDecoration(
                  labelText: 'Re-Enter Password',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.blue)
                  ),
                ),
                validator: (value){
                  return MatchValidator(errorText: "Passwords do not match").validateMatch(value, password);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height/80,),
              Text(
                ro.rstr == null ? "" : ro.rstr,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/80),
              Center(
                child: RaisedButton(
                  color:Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    ro.rerrorstr(null);
                    if(formkey.currentState.validate() == false){
                    }
                    else if (profilePic == false){}
                    else{
                      ro.register(email, password, name, _image).whenComplete(() {
                        if(ro.auth.containsKey("localId")){
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/");
                        }
                      });
                    }
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/40),
            ],
          ),
        ),
      ),
    );
  }
}