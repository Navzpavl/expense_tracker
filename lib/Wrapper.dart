import 'package:expense_tracker/HomePage/HomePage.dart';
import 'package:expense_tracker/SignUpIn/Login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/Controller/Auth.dart';

class Wrapper extends StatefulWidget{

  _Wrap createState() => _Wrap();
}

class _Wrap extends State<Wrapper>{

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    final wo = Provider.of<Auth>(context);
    if (wo.uid == null){
      return Login();
    }
    else{
      return HomePage();
    }
  }
}