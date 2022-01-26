import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:profilebab/Screens/resetpassword.dart';
import 'package:profilebab/bottomnav/bottommain.dart';
import 'package:profilebab/model/step_model.dart';
import 'package:profilebab/widget/ProgressHUD.dart';
import 'package:profilebab/widget/block_button_widget.dart';
import 'package:profilebab/widget/mycolor.dart';
import 'package:profilebab/widget/text_field_widget.dart';
import 'package:profilebab/widget/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isApiCallProcess = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var _controllerpassword = new TextEditingController();
  var _controllernumber = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _upload() async {
    // if (file != null) {
    setState(() {
      isApiCallProcess = true;
    });
    final data = {
      'contact_number': _controllernumber.text,
      'password': _controllerpassword.text,
    };
    Dio dio = new Dio();
    dio.post('https://profilebaba.com/api/login', data: data).then((response) {
      dynamic jsonResponse = jsonDecode(response.toString())['message'];

      if (jsonResponse.toString().contains('User login successfull')) {
        showMessage(jsonResponse.toString(), isApiCallProcess);
        isApiCallProcess = false;
        _controllernumber.clear();
        _controllerpassword.clear();

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (ctx) => Loginscreen()));
      } else {
        showMessage("Something Went Wrong", isApiCallProcess);
        isApiCallProcess = false;
        _controllernumber.clear();
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
    if (message.contains('User login successfull')) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new BottomDas()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
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
                          controller: _controllernumber,
                          onSaved: (input) => input,
                          validator: (input) => input.isEmpty
                              ? "Please Enter Your Mobile Number"
                              : null,
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
                        obscureText: true,
                        controller: _controllerpassword,
                        onSaved: (input) => input,
                        validator: (input) =>
                            input.isEmpty ? "Please Enter Your Password" : null,
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
                          'SIGN IN',
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
                      padding: EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (context) => new Resetpassword()));
                        },
                        child: Center(
                          child: Text(
                            'Forgot your password?',
                            style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(
                                    builder: (context) => new SignupPage()));
                          },
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Don't have an account?",
                                  style: TextStyle(
                                    fontFamily: 'SFUIDisplay',
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                              TextSpan(
                                  text: " Sign Up",
                                  style: TextStyle(
                                    fontFamily: 'SFUIDisplay',
                                    color: MyColors.orange,
                                    fontSize: 15,
                                  ))
                            ]),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (context) => new BottomDas()));
                        },
                        child: Center(
                          child: Text(
                            'Skip',
                            style: TextStyle(
                                fontFamily: 'SFUIDisplay',
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
