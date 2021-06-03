import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';

class Auth extends ChangeNotifier{

  bool loading = true;
  int selector = 0;
  double sum = 0;
  List expenses;
  var usrdoc;
  String uid;
  Map auth;
  String lstr;
  String rstr;
  String url = "https://firestore.googleapis.com/v1/projects/expense-tracker-39c6f/databases/(default)/documents/";

  void lerrorstr(String s){
    lstr = s;
    notifyListeners();
  }

  void rerrorstr(String s){
    rstr = s;
    notifyListeners();
  }

  Future login(String email, String pass) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    Map credential = {"email": email, "password": pass};
    await post(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=KEY_REMOVED",
        body: credential
    ).catchError((e){
      if(email == null || pass == null){
        lerrorstr("Enter valid email and password");
      }
      else{
        lerrorstr(e.toString());
      }
    }).then((value) async{
      auth = jsonDecode(value.body);
      if(auth["localId"] == null){
        lerrorstr("Enter valid email and password");
      }
      else{
        pref.setString("User Id", auth["localId"]);
        getuserdata();
      }
    });
  }

  Future register(String email, String pass, String name, File img) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    Map credentials = {"email": email, "password": pass};
    await post(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=KEY_REMOVED",
        body: credentials
    ).catchError((e){
      rerrorstr(e.toString());
    }).then((value) async{
      auth = jsonDecode(value.body);
      if(auth.containsKey("error")){
        if(auth["error"].containsValue("EMAIL_EXISTS")){
          rerrorstr("Email already exists");
        }
      }
      else{
        String image = base64Encode(await img.readAsBytes());
        Map details = {"fields": {"Name": {"stringValue": name}, "Email": {"stringValue": email}, "Image": {"stringValue": image}}};
        await post(
          url+"Users?documentId="+auth["localId"],
          body: jsonEncode(details),
        ).then((value) => print(value.body));
        pref.setString("User Id", auth["localId"]);
        getuserdata();
      }
    });
  }

  Future getuserdata() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.containsKey("User Id")? uid = pref.getString("User Id") : uid = null;
    if(uid != null){
      Response r = await get(url+"Users/"+uid);
      usrdoc = jsonDecode(r.body);
      if(usrdoc.containsKey("error") && usrdoc["error"]["status"] == "NOT_FOUND"){
        signOut();
      }
      else{
        if (loading == true){
          getdata();
          loading = false;
        }
      }
    }
  }

  Future getalldata() async{
    sum = 0;
    Response r = await get(url+"Users/"+uid+"/Expenses");
    expenses = jsonDecode(r.body)["documents"];
    if(expenses != null){
      if(expenses.length > 1){
      expenses.sort((b,a)=> a["fields"]["Date"]["timestampValue"].compareTo(b["fields"]["Date"]["timestampValue"]));
      }
      expenses.forEach((element) {
        sum = sum + int.parse(element["fields"]["Amount"]["integerValue"]);
      });
      notifyListeners();
    }
  }

  void addExpense(Map details, double amount){
    expenses.add(details);
    if(expenses.length > 1){
      expenses.sort((b,a)=> a["fields"]["Date"]["timestampValue"].compareTo(b["fields"]["Date"]["timestampValue"]));
    }
    sum = sum + amount;
  }

  Future postTransaction(String title, double amount, DateTime date ) async{
    Map details = {"fields": {"Title": {"stringValue": title}, "Amount": {"integerValue": amount}, "Date": {"timestampValue": date.toUtc().toIso8601String()}}};
    await post(
        url+"Users/"+uid+"/Expenses",
        body: jsonEncode(details)
    ).whenComplete(() {
      if(selector == 0){
        addExpense(details, amount);
        expenses = null;
        getdata();
      }
      else if(selector == 1){
        if (date.isAfter(DateTime.now().subtract(Duration(days: 6)))){
          addExpense(details, amount);
          expenses = null;
          getCustomData((DateTime.now().subtract(Duration(days: 6))));
        }
      }
      else if(selector == 2){
        if (date.isAfter(DateTime.now().subtract(Duration(days: 30)))){
          addExpense(details, amount);
          expenses = null;
          getCustomData((DateTime.now().subtract(Duration(days: 30))));
        }
      }
      notifyListeners();
    });
  }

  Future signOut() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("User Id");
    uid = null;
    auth = null;
    usrdoc = null;
    expenses = null;
    notifyListeners();
  }

  Future deleteexp(String s, int pos, double amount) async{
    print(s);
    await delete(
        "https://firestore.googleapis.com/v1/" + s
    ).whenComplete(() => expenses.removeAt(pos));
    sum -=amount;
    notifyListeners();
  }

  Future getdata() async{
    print('Reading');
    sum = 0;
    Map query = {
      "structuredQuery":{
        "select": {
          "fields": [
            {"fieldPath": "Title"},
            {"fieldPath": "Amount"},
            {"fieldPath": "Date"},
          ]
        },
        "from":[
          {"collectionId": "Expenses"}
        ],
        /*"where":{
          "fieldFilter":{
            "field":{
              "fieldPath": "Date"
            },
            "op": "GREATER_THAN_OR_EQUAL",
            "value": {"timestampValue": DateTime.parse(DateTime.now().year.toString() + "-01-01" ).toUtc().toIso8601String()}
          }
        }*/
      }
    };
    await post(
      url+"Users/"+uid+":runQuery",
      body: jsonEncode(query),
    ).then((value) {
      expenses = [];
      jsonDecode(value.body).forEach((value){
        if (value["document"]!=null){
          expenses.add(value["document"]);
          sum = sum + double.parse(value["document"]["fields"]["Amount"]["integerValue"]);
        }
        else { }
      });
    });
    if(expenses.length > 1){
      expenses.sort((b,a)=> a["fields"]["Date"]["timestampValue"].compareTo(b["fields"]["Date"]["timestampValue"]));
    }
    notifyListeners();
  }

  Future getCustomData(DateTime d) async{
    print('Reading');
    sum = 0;
    expenses = null;
    expenses = [];
    Map query = {
      "structuredQuery":{
        "select": {
          "fields": [
            {"fieldPath": "Title"},
            {"fieldPath": "Amount"},
            {"fieldPath": "Date"},
          ]
        },
        "from":[
          {"collectionId": "Expenses"}
        ],
        "where":{
          "fieldFilter":{
            "field":{
              "fieldPath": "Date"
            },
            "op": "GREATER_THAN_OR_EQUAL",
            "value": {"timestampValue": d.toUtc().toIso8601String()}
          }
        }
      }
    };
    await post(
      url+"Users/"+uid+":runQuery",
      body: jsonEncode(query),
    ).then((value) {
      jsonDecode(value.body).forEach((value){
        if (value["document"] != null) {
          expenses.add(value["document"]);
        sum = sum + double.parse(value["document"]["fields"]["Amount"]["integerValue"]);
        }
      });
    });
    if(expenses.length > 1){
      expenses.sort((b,a)=> a["fields"]["Date"]["timestampValue"].compareTo(b["fields"]["Date"]["timestampValue"]));
    }
    notifyListeners();
  }
}
