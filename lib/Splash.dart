import 'package:expense_tracker/Controller/Auth.dart';
import 'package:expense_tracker/Wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';



class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<Auth>(context);
    if(pro.loading == true){
      pro.getuserdata();
    }
    return SplashScreen(
        seconds: 3,
        title: Text(
            'Expense Tracker',
            style: TextStyle(
                fontSize: 30,
                color:Colors.blue,
                fontWeight:FontWeight.w700
            )
        ),
        loadingText: Text('Loading...'),
        loaderColor: Color(0xff01608f),
        backgroundColor: Colors.white,
        photoSize:150.0 ,
        navigateAfterSeconds:Wrapper()
    );
  }
}