import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:profilebab/Helper/Color.dart';
import 'package:profilebab/Helper/Constant.dart';
import 'package:profilebab/Helper/Session.dart';
import 'package:profilebab/Screens/Privacy_Policy.dart';
import 'package:profilebab/model/ChatMessage.dart';
import 'package:profilebab/widget/ChatBubble.dart';
import 'package:profilebab/widget/DefaultGrabbing.dart';
import 'package:profilebab/widget/ProgressHUD.dart';
import 'package:profilebab/widget/drawer_link_widget.dart';
import 'package:profilebab/widget/notification.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:http/http.dart' as http;

class BottomDas extends StatefulWidget {
  @override
  BottomDasState createState() => BottomDasState();
}

enum MessageType {
  Sender,
  Receiver,
}

class BottomDasState extends State<BottomDas> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  final PageStorageBucket bucket = PageStorageBucket();
  final InAppReview _inAppReview = InAppReview.instance;
  int id;
  double _height;
  double _width;
  bool isExpanded = false;
  List data, datachat;
  bool isApiCallProcess = false;
  final db = FirebaseFirestore.instance;
  DocumentReference _documentReference;
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';
  SharedPreferences preferences;
  SnappingSheetController snappingSheetController = SnappingSheetController();

  List<ChatMessage> chatMessage = [
    ChatMessage(message: "Hi John", type: MessageType.Receiver),
    ChatMessage(message: "Hope you are doin good", type: MessageType.Receiver),
    ChatMessage(
        message: "Hello Jane, I'm good what about you",
        type: MessageType.Sender),
    ChatMessage(
        message: "I'm fine, Working from home", type: MessageType.Receiver),
    ChatMessage(message: "Oh! Nice. Same here man", type: MessageType.Sender),
  ];

  void GetJsondata() async {
    isApiCallProcess = true;
    var Response = await http.get(
        Uri.parse('https://profilebaba.com/api/category-list'),
        headers: {"Accept": "application/json"});

    setState(() {
      if (jsonDecode(Response.body)['success'].toString().contains("true")) {
        data = jsonDecode(Response.body)['data'];
        print(data);
        isApiCallProcess = false;
      } else {
        isApiCallProcess = false;
      }
    });
  }

  void Getadminschat() async {
    isApiCallProcess = true;
    var Response = await http.get(
        Uri.parse(
            'https://profilebaba.com/api/get-admin-chat/' + id.toString()),
        headers: {"Accept": "application/json"});
    // print(id);
    // print("amit");
    setState(() {
      if (jsonDecode(Response.body)['success'].toString().contains("true")) {
        datachat = jsonDecode(Response.body)['data'];
        print(data);
        isApiCallProcess = false;
      } else {
        isApiCallProcess = false;
      }
    });
  }

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.getToken();
    getid();
    Getadminschat();
    GetJsondata();
    super.initState();
    _scrollController = ScrollController();
  }

  getid() async {
    preferences = await SharedPreferences.getInstance();
    id = preferences.getInt("user_id");
  }

  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 95.0;

  void _expand() {
    setState(() {
      isExpanded ? isExpanded = false : isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Colors.white,
                Colors.white,
              ]),
        )),
        iconTheme: IconThemeData(color: Colors.deepOrangeAccent),
        // leading: IconButton(
        //   icon: new Icon(Icons.sort, color: Colors.black87),
        //   onPressed: () => {},
        // ),
        // like this!
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 35,
            ),
            SizedBox(
              width: 20,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Profile",
                    style: TextStyle(
                        fontFamily: 'SFUIDisplay',
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                TextSpan(
                    text: " Baba",
                    style: TextStyle(
                        fontFamily: 'SFUIDisplay',
                        color: Colors.deepOrangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w800))
              ]),
            ),
          ],
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(7),
              child: Icon(Icons.account_circle)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome".tr,
                        style: Get.textTheme.headline5.merge(
                            TextStyle(color: Theme.of(context).accentColor))),
                    SizedBox(height: 5),
                    Text("Login account or create new one for free".tr,
                        style: Get.textTheme.bodyText1),
                    SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            // Get.toNamed(Routes.LOGIN);
                          },
                          color: Get.theme.accentColor,
                          height: 40,
                          elevation: 0,
                          child: Wrap(
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 9,
                            children: [
                              Icon(Icons.exit_to_app_outlined,
                                  color: Get.theme.primaryColor, size: 24),
                              Text(
                                "Login".tr,
                                style: Get.textTheme.subtitle1
                                    .merge(TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          shape: StadiumBorder(),
                        ),
                        MaterialButton(
                          color: Get.theme.focusColor.withOpacity(0.2),
                          height: 40,
                          elevation: 0,
                          onPressed: () {
                            // Get.toNamed(Routes.REGISTER);
                          },
                          child: Wrap(
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 9,
                            children: [
                              Icon(Icons.person_add_outlined,
                                  color: Get.theme.hintColor, size: 24),
                              Text(
                                "Register".tr,
                                style: Get.textTheme.subtitle1.merge(
                                    TextStyle(color: Get.theme.hintColor)),
                              ),
                            ],
                          ),
                          shape: StadiumBorder(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // GestureDetector(
            //   onTap: () {
            //     Get.find<RootController>().changePageOutRoot(3);
            //   },
            //   child: UserAccountsDrawerHeader(
            //     decoration: BoxDecoration(
            //       color: Theme.of(context).hintColor.withOpacity(0.1),
            //     ),
            //     accountName: Text(
            //       Get.find<AuthService>().user.value.name,
            //       style: Theme.of(context).textTheme.headline6,
            //     ),
            //     accountEmail: Text(
            //       Get.find<AuthService>().user.value.email,
            //       style: Theme.of(context).textTheme.caption,
            //     ),
            //     currentAccountPicture: Stack(
            //       children: [
            //         SizedBox(
            //           width: 80,
            //           height: 80,
            //           child: ClipRRect(
            //             borderRadius:
            //             BorderRadius.all(Radius.circular(80)),
            //             child: CachedNetworkImage(
            //               height: 80,
            //               width: double.infinity,
            //               fit: BoxFit.cover,
            //               imageUrl: Get.find<AuthService>()
            //                   .user
            //                   .value
            //                   .avatar
            //                   .thumb,
            //               placeholder: (context, url) => Image.asset(
            //                 'assets/img/loading.gif',
            //                 fit: BoxFit.cover,
            //                 width: double.infinity,
            //                 height: 80,
            //               ),
            //               errorWidget: (context, url, error) =>
            //                   Icon(Icons.error_outline),
            //             ),
            //           ),
            //         ),
            //         Positioned(
            //           top: 0,
            //           right: 0,
            //           child: Get.find<AuthService>()
            //               .user
            //               .value
            //               .verifiedPhone ??
            //               false
            //               ? Icon(
            //             Icons.check_circle,
            //             color: Theme.of(context).accentColor,
            //             size: 24,
            //           )
            //               : SizedBox(),
            //         )
            //       ],
            //     ),
            //   ),
            // )
            SizedBox(height: 20),
            DrawerLinkWidget(
              icon: Icons.assignment_outlined,
              text: "Bookings",
              onTap: (e) {},
            ),
            DrawerLinkWidget(
              icon: Icons.folder_special_outlined,
              text: "My Services",
              onTap: (e) {},
            ),
            DrawerLinkWidget(
              icon: Icons.notifications_none_outlined,
              text: "Notifications",
              onTap: (e) {},
            ),
            DrawerLinkWidget(
              icon: Icons.chat_outlined,
              text: "Messages",
              onTap: (e) {},
            ),

            ListTile(
              dense: true,
              title: Text(
                "Help & Privacy",
                style: Get.textTheme.caption,
              ),
              trailing: Icon(
                Icons.remove,
                color: Get.theme.focusColor.withOpacity(0.3),
              ),
            ),
            DrawerLinkWidget(
              icon: Icons.help_outline,
              text: "Help & FAQ",
              onTap: (e) {},
            ),
            DrawerLinkWidget(
              icon: Icons.privacy_tip_outlined,
              text: "Privacy Policy",
              onTap: (e) async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicy(),
                    ));
              },
            ),
            DrawerLinkWidget(
              icon: Icons.article_outlined,
              text: "Terms & Condition",
              onTap: (e) async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicy(),
                    ));
              },
            ),
            DrawerLinkWidget(
              icon: Icons.person_outline,
              text: "Rate Us",
              onTap: (e) {
                _openStoreListing();
              },
            ),
            DrawerLinkWidget(
              icon: Icons.settings_outlined,
              text: "Share",
              onTap: (e) {
                var str =
                    "$appName\n\n${'APPFIND'}$androidLink$packageName\n\n ${'IOSLBL'}\n$iosLink$iosPackage";
                Share.share(str);
              },
            ),
            DrawerLinkWidget(
              icon: Icons.logout,
              text: "Logout",
              onTap: (e) async {
                logOutDailog();
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                "Version".tr,
                style: Get.textTheme.caption,
              ),
              trailing: Icon(
                Icons.remove,
                color: Get.theme.focusColor.withOpacity(0.3),
              ),
            )
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: Column(
              children: [
                data != null
                    ? Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                            ),
                            itemCount: data.length == null ? 0 : data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      // snappingSheetController
                                      //     .setSnappingSheetPosition(100);
                                      snappingSheetController.snapToPosition(
                                        SnappingPosition.factor(
                                            positionFactor: 0.90),
                                      );
                                    },
                                    child: Card(
                                      elevation: 8,
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 1)),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        child: Image.network(
                                          'https://profilebaba.com/uploads/category/' +
                                              data[index]["icon"],
                                          height: _height / 10,
                                          width: _width / 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      data[index]["title"],
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      )
                    : Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.deepOrangeAccent,
                              Colors.orangeAccent,
                            ],
                            begin:
                                Alignment.topLeft, //begin of the gradient color
                            end: Alignment
                                .bottomRight, //end of the gradient color
                            stops: [0, 0.5] //stops for individual color
                            //set the stops number equal to numbers of color
                            ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            "Grow your Business",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: RaisedButton(
                                    onPressed: () {},
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "Sign up for Free",
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: RaisedButton(
                                    onPressed: () {},
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.white,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.call,
                                              color: Colors.blueAccent),
                                          SizedBox(width: 10),
                                          Text(
                                            "Call Us",
                                            style: TextStyle(
                                                color: Colors.blueAccent),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            panelBuilder: (sc) => _panel(sc),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
          ),
        ],
      ),
    );
  }

  logOutDailog() async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          content: Text(
            'LOGOUTTXT',
            style: Theme.of(this.context)
                .textTheme
                .subtitle1
                .copyWith(color: colors.fontColor),
          ),
          actions: <Widget>[
            new TextButton(
                child: Text(
                  'NO',
                  style: Theme.of(this.context).textTheme.subtitle2.copyWith(
                      color: colors.lightBlack, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                }),
            new TextButton(
                child: Text(
                  'YES',
                  style: Theme.of(this.context).textTheme.subtitle2.copyWith(
                      color: colors.fontColor, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  //clearUserSession();
                  // favList.clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', (Route<dynamic> route) => false);
                })
          ],
        );
      });
    }));
  }

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
        appStoreId: appStoreId,
        microsoftStoreId: 'microsoftStoreId',
      );

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: datachat.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: Align(
                    alignment: (datachat[index] == MessageType.Receiver
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    // child: Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(30),
                    //     color: (widget.chatMessage.type == MessageType.Receiver
                    //         ? Colors.white
                    //         : Colors.grey.shade200),
                    //   ),
                    //   padding: EdgeInsets.all(16),
                    //   child: Text(widget.chatMessage.message),
                    // ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 16, bottom: 10, right: 70),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: TextFormField(
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(20.0),
                        ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(color: Colors.grey[800]),
                      hintText: "Type your message",
                      fillColor: Colors.white70),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                child: Container(
                  padding: EdgeInsets.only(bottom: 10, right: 10),
                  height: 60,
                  width: 60,
                  child: FloatingActionButton(
                    onPressed: () {
                      chatwithadmin();
                    },
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.blueAccent,
                    elevation: 0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void chatwithadmin() {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": "9899740760",
      "message": "sfhsf",
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    db
        .collection("Adminchat")
        .doc("9899740760-admin")
        .collection("ChatHistory")
        .add(chatMessageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  // getchats() {
  //   QuerySnapshot snap = await db.collection('collection').getDocuments();
  //
  //   snap.documents.forEach((document) {
  //     print(document.documentID);
  //   });
  // }
}
