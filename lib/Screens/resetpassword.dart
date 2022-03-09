import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:profilebab/Screens/Login.dart';
import 'package:profilebab/widget/ProgressHUD.dart';
import 'package:profilebab/widget/mycolor.dart';

import 'otp.dart';

class Resetpassword extends StatefulWidget {
  const Resetpassword({Key key}) : super(key: key);

  @override
  _ResetpasswordState createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  bool isApiCallProcess = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _controllernumber = new TextEditingController();
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;

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
    };
    Dio dio = new Dio();
    dio
        .post('https://profilebaba.com/api/forgot-password', data: data)
        .then((response) {
      dynamic jsonResponse = jsonDecode(response.toString())['message'];

      if (jsonResponse
          .toString()
          .contains('Otp sent on your registered mobile number')) {
        showMessage(jsonResponse.toString(), isApiCallProcess);
        isApiCallProcess = false;
        _controllernumber.clear();

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (ctx) => Loginscreen()));
      } else {
        showMessage("Something Went Wrong", isApiCallProcess);
        isApiCallProcess = false;
        _controllernumber.clear();
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
    if (message.contains('Otp sent on your registered mobile number')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Otp()),
      );
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
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xfff7f6fb),
          key: scaffoldKey,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(
                                builder: (context) => new LoginPage()));
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/illustration-2.png',
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'SEND OTP',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Add your phone number. we'll send you a verification code so we know you're real",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Container(
                    padding: EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _controllernumber,
                          keyboardType: TextInputType.number,
                          onSaved: (input) => input,
                          validator: (input) => input.isEmpty
                              ? "Please Enter Your Mobile No"
                              : null,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10)),
                            prefix: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '(+91)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            suffixIcon: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 32,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _upload();
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyColors.blue),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text(
                                'SEND OTP',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
