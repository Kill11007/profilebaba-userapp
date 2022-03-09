import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:profilebab/Helper/Color.dart';
import 'package:profilebab/Helper/Session.dart';

class Faq extends StatefulWidget {
  final String title;

  const Faq({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Faqstate();
  }
}

class Faqstate extends State<Faq> with TickerProviderStateMixin {
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String privacy;
  Animation buttonSqueezeanimation;
  AnimationController buttonController;
  bool _isNetworkAvail = true;
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close();
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    buttonSqueezeanimation = new Tween(
      begin: 0.7,
      end: 50.0,
    ).animate(new CurvedAnimation(
      parent: buttonController,
      curve: new Interval(
        0.0,
        0.150,
      ),
    ));
  }

  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }),
  ].toSet();

  var url = "https://profilebaba.com/faq";

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      javascriptChannels: jsChannels,
      mediaPlaybackRequiresUserGesture: false,
      appBar: AppBar(
        titleSpacing: 0,
        leading: Builder(builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.all(10),
            decoration: shadow(),
            child: Card(
              elevation: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () => Navigator.of(context).pop(),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
          );
        }),
        title: Text(
          "FAQ",
          style: TextStyle(
            color: colors.fontColor,
          ),
        ),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.redAccent,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
