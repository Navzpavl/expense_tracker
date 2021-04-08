import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child:
                  CircularProgressIndicator(
                    backgroundColor: Color(0xff01608f),
                    semanticsLabel: 'Please wait..',
                  ),
                ),
                Text('Loading..')
              ])
      ),
    );
  }
}