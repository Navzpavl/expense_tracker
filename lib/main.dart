import 'package:expense_tracker/Controller/Auth.dart';
import 'package:expense_tracker/HomePage/HomePage.dart';
import 'package:expense_tracker/SignUpIn/Login.dart';
import 'package:expense_tracker/SignUpIn/SignUp.dart';
import 'package:expense_tracker/Splash.dart';
import 'package:expense_tracker/Wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Auth> (create: (context) => Auth(),
    child: MaterialApp(
      initialRoute: "/",
      routes: {
        "/" : (context) => Splash(),
        "/w" : (context) => Wrapper(),
        "/s" : (context) => SignUp(),
        "/login" : (context) => Login(),
        "/rHome" : (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
    ),
    );
  }
}
