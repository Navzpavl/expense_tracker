import 'package:expense_tracker/Controller/Auth.dart';
import 'package:expense_tracker/Loading.dart';
import 'package:expense_tracker/Profile/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formkey = GlobalKey<FormState>();
  String t;
  String am;
  String fd;
  DateTime date;
  FocusNode myFocusNode = new FocusNode();
  FocusNode myFocusNode1 = new FocusNode();
  bool filter = false, data1 = false;

  @override
  Widget build(BuildContext context) {
    final sProvider = Provider.of<Auth>(context);

      return Scaffold(
        drawer:
        Drawer(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height*0.08,
              ),
              Text('Expense Tracker',
                style: TextStyle(
                    color: Color(0xff01608f),
                    fontSize: 20,
                    fontWeight: FontWeight.w800
                ),),
              filter == false?
              Column(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child:
                    ListTile(
                      title: Text('Filters',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      onTap: (){
                        setState(() {
                          filter = true;
                        });
                      },
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child:
                    ListTile(
                      title: Text('My Profile',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Profile()
                        ));
                      },
                    ),
                  ),
                ],
              ):Column(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child:
                    ListTile(
                      title: Text('Last Seven Days Expense',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      onTap: (){
                        sProvider.getCustomData(DateTime.now().subtract(Duration(days: 6)));
                        sProvider.selector =1;
                        setState(() {
                          filter = false;
                        });
                      },
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child:
                    ListTile(
                      title: Text('Last Month Expense',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      onTap: (){
                        sProvider.getCustomData(DateTime.now().subtract(Duration(days: 30)));
                        sProvider.selector =2;
                        setState(() {
                          filter = false;
                        });
                      },
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child:
                    ListTile(
                      title: Text('Clear Filters',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      onTap: (){
                        sProvider.getalldata();
                        setState(() {
                          filter = false;
                        });
                        sProvider.selector =0;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xff01608f),
          title: Text('Expense Tracker'),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: (){
                sProvider.signOut();
              },
              label: Text(
                'Sign Out',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              icon: Icon(Icons.exit_to_app,
                color: Colors.white,),
            )
          ],
        ),
        body: Container(
            padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 50,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 100,
                            ),
                            Text(
                              "Total amount spent :",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "\u20B9" + sProvider.sum.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).size.height / 50)*.8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  child: Text(sProvider.selector == 0? 'All transactions':sProvider.selector == 1?'Spend in Last 7 Days': 'Spend in Last Month',
                                  style: TextStyle(
                                    fontSize: 10
                                  ),),
                                  margin: EdgeInsets.only(right: 10),
                                )
                              ],
                            ),
                            SizedBox(
                              height: (MediaQuery.of(context).size.height / 50)*.2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: sProvider.expenses == null ? LoadingWidget() : sProvider.expenses.length == 0
                      ? Center(child: Text("No expense reports are available"))
                      : ListView.builder(
                      itemCount: sProvider.expenses.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(10, 1, 10, 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor: Colors.purple,
                                radius:
                                MediaQuery.of(context).size.height / 20,
                                child: Text(
                                  "\u20B9" +
                                      sProvider.expenses[index]["fields"]
                                      ["Amount"]["integerValue"]
                                          .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500
                                  ),
                                )),
                            title: Text(
                              sProvider.expenses[index]["fields"]["Title"]
                              ["stringValue"]
                                  .toString()[0].toUpperCase()+sProvider.expenses[index]["fields"]["Title"]
                              ["stringValue"]
                                  .toString().substring(1),
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.width / 23,
                                  fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              DateFormat.yMMMd().format(DateTime.parse(
                                  sProvider.expenses[index]["fields"]
                                  ["Date"]["timestampValue"])
                                  .toLocal()),
                              style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.width / 30),
                            ),
                            trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 23,
                                ),
                                onPressed: () {
                                  sProvider.deleteexp(
                                      sProvider.expenses[index]["name"],
                                      index, double.parse(sProvider.expenses[index]["fields"]["Amount"]["integerValue"].toString()));
                                }),
                          ),
                        );
                      }),
                ),
              ],
            )),
        floatingActionButton: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
          child: FloatingActionButton(
            backgroundColor: Colors.orange,
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              fd = null;
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(8.0))),
                  isScrollControlled: true,
                  builder: (context) => Container(
                    //padding: MediaQuery.of(context).viewInsets,
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                            child: TextFormField(
                              focusNode: myFocusNode1,
                              validator: RequiredValidator(
                                  errorText: 'Title cannot be empty'),
                              onChanged: (String val) {
                                t = val;
                              },
                              decoration: new InputDecoration(
                                  hintText: 'Enter Title',
                                  labelText: 'Title',
                                  labelStyle: TextStyle(
                                      color: myFocusNode1.hasFocus
                                          ? Colors.purple
                                          : Colors.grey),
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          width: 2, color: Colors.purple))),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                            child: TextFormField(
                              focusNode: myFocusNode,
                              keyboardType: TextInputType.number,
                              validator: RequiredValidator(
                                  errorText: 'Amount cannot be empty'),
                              onChanged: (String val) {
                                am = val;
                              },
                              maxLength: 4,
                              decoration: new InputDecoration(
                                hintText: 'Enter Amount',
                                labelText: 'Amount',
                                labelStyle: TextStyle(
                                    color: myFocusNode.hasFocus
                                        ? Colors.purple
                                        : Colors.grey),
                                focusedBorder: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: 2, color: Colors.purple)),
                              ),
                            ),
                          ),
                          StatefulBuilder(builder: (BuildContext context,
                              StateSetter setDateState) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(date == null
                                      ? ('No Date chosen!')
                                      : DateFormat.yMMMd().format(date)),
                                  FlatButton(
                                      child: Text(
                                        'Choose Date',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          decoration:
                                          TextDecoration.underline,
                                          color: Colors.purple,
                                        ),
                                      ),
                                      onPressed: () {
                                        showRoundedDatePicker(
                                          context: context,
                                          borderRadius: 0,
                                          theme: ThemeData(
                                            primarySwatch: Colors.orange,
                                            primaryColor: Colors.purple,
                                            accentColor: Colors.orange,
                                          ),
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2050),
                                        ).then((value) {
                                          if (value == null) {
                                            return;
                                          }
                                          setDateState(() {
                                            date = value;
                                          });
                                        });
                                        setState(() {});
                                      })
                                ],
                              ),
                            );
                          }),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            alignment: Alignment(1.0, 1.0),
                            child: MaterialButton(
                              onPressed: () {
                                if (formkey.currentState.validate() ==
                                    false) {
                                } else if (date == null) {
                                } else {
                                  sProvider
                                      .postTransaction(
                                      t, double.parse(am), date)
                                      .whenComplete(() {
                                    date = null;
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                              child: Text(
                                'Add Transaction',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              color: Colors.purple,
                              minWidth: 100,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                          Text('\n'),
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
  }
}
