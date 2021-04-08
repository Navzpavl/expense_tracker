import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/Controller/Auth.dart';

class Login extends StatefulWidget{

  _Login createState() => _Login();
}

class _Login extends State<Login>{

  final formKey = GlobalKey<FormState>();
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    final lo = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff01608f),
        title: Text('Sign In'),
        actions: [
          FlatButton.icon(onPressed:(){
            Navigator.pop(context);
            Navigator.pushNamed(context, "/s");
          },
            icon:Icon(Icons.person,
              color: Colors.white,),
            label: Text('Sign Up',
              style: TextStyle(
                  color: Colors.white
              ),),)
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/20, MediaQuery.of(context).size.height/12, MediaQuery.of(context).size.width/20, 0.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/15,),
              TextFormField(
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
                validator: RequiredValidator(errorText: "Enter your email"),
                onChanged: (value) => email = value,
              ),
              SizedBox(height: MediaQuery.of(context).size.height/50,),
              TextFormField(
                obscureText: true,
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
                validator: RequiredValidator(errorText: "Enter Password"),
                onChanged: (value) => password = value,
              ),
              SizedBox(height: MediaQuery.of(context).size.height/70,),
              Text(
                lo.lstr == null ? "" : lo.lstr,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/40),
              Center(
                child: RaisedButton(
                  elevation: 3,
                  color:Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textColor: Colors.white,
                  onPressed: () {
                    lo.lerrorstr(null);
                    lo.login(email, password);
                    setState(() {
                    });
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/3.2),
            ],
          ),
        ),
      ),
    );
  }
}