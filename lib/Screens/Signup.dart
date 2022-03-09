import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:profilebab/Screens/Login.dart';
import 'package:profilebab/bottomnav/bottommain.dart';
import 'package:profilebab/widget/ProgressHUD.dart';
import 'package:profilebab/widget/mycolor.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isApiCallProcess = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences preferences;
  var user_id;
  final db = FirebaseFirestore.instance;
  DocumentReference _documentReference;
  var _controllername = new TextEditingController();
  var _controlleremail = new TextEditingController();
  var _controllernumber = new TextEditingController();
  var _controllerpassword = new TextEditingController();

  Future<void> user_idsave(int id, bool login_status) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setInt("user_id", id);
    preferences.setBool("is_login", login_status);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addDataToDb(String response) {
    _documentReference = db.collection("users").doc(_controllernumber.text);
    _documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        // Navigator.pushReplacement(context,
        //     new MaterialPageRoute(builder: (context) => AllUsersScreen()));
      } else {
        db.collection("users").doc(_controllernumber.text).set({
          "userName": _controllername.text,
          "mail": _controlleremail.text,
          "password": _controllerpassword.text,
        });
        _controllernumber.clear();
        _controlleremail.clear();
        _controllername.clear();
        _controllerpassword.clear();
        showMessage(response.toString(), isApiCallProcess);
      }
    });
  }

  Future _upload() async {
    // setState(() {
    //   isApiCallProcess = true;
    // });
    final data = {
      'name': _controllername.text,
      'email': _controlleremail.text,
      'password': _controllerpassword.text,
      'contact_number': _controllernumber.text,
    };
    Dio dio = new Dio();
    dio
        .post('https://profilebaba.com/api/register', data: data)
        .then((response) async {
      dynamic jsonResponse = jsonDecode(response.toString())['message'];
      dynamic id = jsonDecode(response.toString())['data'];
      if (jsonResponse.toString().contains('User created successfully.')) {
        isApiCallProcess = false;
        user_id = id["user_id"];
        print(data.toString());
        print(user_id);
        print("registerid");
        user_idsave(user_id, true);
        // addDataToDb(jsonResponse);
      } else {
        showMessage("Something Went Wrong", isApiCallProcess);
        isApiCallProcess = false;
        _controllernumber.clear();
        _controlleremail.clear();
        _controllername.clear();
        _controllerpassword.clear();
      }
    }).catchError((error) => print(error));
    // }
  }

  void showMessage(String message, bool iscallApi) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: MyColors.blue,
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    ));
    setState(() {
      iscallApi = false;
    });
    if (message.contains('User created successfully.')) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new BottomDas()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => new LoginPage()));
        },
        child: Scaffold(
          key: scaffoldKey,
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/image1.png'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter)),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 270),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(23),
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            controller: _controllername,
                            onSaved: (input) => input,
                            validator: (input) => input.isEmpty
                                ? "Please Enter Your Full Name"
                                : null,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person_outline),
                                labelStyle: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            controller: _controlleremail,
                            onSaved: (input) => input,
                            validator: (input) => input.isEmpty
                                ? "Please Enter Your Email"
                                : null,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                                labelStyle: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Container(
                          color: Color(0xfff5f5f5),
                          child: TextFormField(
                            onSaved: (input) => input,
                            validator: (input) => input.isEmpty
                                ? "Please Enter Your Mobile No"
                                : null,
                            controller: _controllernumber,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mobile No',
                                prefixIcon: Icon(Icons.mobile_friendly),
                                labelStyle: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ),
                      Container(
                        color: Color(0xfff5f5f5),
                        child: TextFormField(
                          controller: _controllerpassword,
                          obscureText: true,
                          onSaved: (input) => input,
                          validator: (input) => input.isEmpty
                              ? "Please Enter Your password"
                              : null,
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              labelStyle: TextStyle(fontSize: 15)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: MaterialButton(
                          onPressed: () {
                            _upload();
                          }, //since this is only a UI app
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'SFUIDisplay',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: MyColors.blue,
                          elevation: 0,
                          minWidth: 400,
                          height: 50,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Already have an account?",
                                    style: TextStyle(
                                      fontFamily: 'SFUIDisplay',
                                      color: Colors.black,
                                      fontSize: 15,
                                    )),
                                TextSpan(
                                    text: " Sign In",
                                    style: TextStyle(
                                      fontFamily: 'SFUIDisplay',
                                      color: MyColors.orange,
                                      fontSize: 15,
                                    ))
                              ]),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
