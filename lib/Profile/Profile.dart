import 'dart:convert';

import 'package:expense_tracker/Controller/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pProvider = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff01608f),
        title: Text('My Profile',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white
        ),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff01608f),
                width: 1),
                borderRadius: BorderRadius.all(Radius.circular(12))
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.memory(base64Decode(pProvider.usrdoc["fields"]["Image"]["stringValue"]),
                width: MediaQuery.of(context).size.width/3,
                height: MediaQuery.of(context).size.width/3,
                fit: BoxFit.cover,)
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.04,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Name',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff01608f),
                          fontSize: 16
                      ),),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.01,
                    ),
                    Text('Email',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff01608f),
                          fontSize: 16
                      ),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("  : " + pProvider.usrdoc["fields"]["Name"]["stringValue"],
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff01608f),
                          fontSize: 16
                      ),),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.01,
                    ),
                    Text("  : " + pProvider.usrdoc["fields"]["Email"]["stringValue"],
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff01608f),
                        fontSize: 16
                      ),),
                  ],
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.2,)
          ],
        )
        ),
      );
  }
}
