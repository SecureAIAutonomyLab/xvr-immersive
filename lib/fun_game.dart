import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: UnityDemoScreen(),
    );
  }
}

class UnityDemoScreen extends StatefulWidget {

  @override
  _UnityDemoScreenState createState() => _UnityDemoScreenState();
}

class _UnityDemoScreenState extends State<UnityDemoScreen>{
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  UnityWidgetController unityWidgetController;

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Unity in Flutter"),
        leading: IconButton(
          icon: Icon(Icons.reset_tv),
          onPressed: () {
            unityWidgetController.quit();
          },
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () {
            return;
          },
          child: Container(
            color: Colors.black,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                UnityWidget(
                onUnityCreated: onUnityCreated,
                ),
                Row(
                  children: [
                    SizedBox( width: width/2 - 48,
                      child: GestureDetector(
                        onTapDown: tapDownLeft,
                        onTapUp: tapUpLeft,
                      )
                    ),
                    SizedBox( width: width/2 - 48,
                      child: GestureDetector(
                        onTapDown: tapDownRight,
                        onTapUp: tapUpRight,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 230),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: TextButton(
                        child: Text("Jump",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        onPressed: () {
                          jumpButtonPressed();
                        },
                      ),
                    ),
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }

  void tapDownLeft(TapDownDetails details) {
    print("DownLeft");
    unityWidgetController.postMessage(
        'Player',
        'moveLeftStart', '');
  }

  void tapUpLeft(TapUpDetails details) {
    print("UpLeft");
    unityWidgetController.postMessage(
        'Player',
        'moveLeftEnd', '');
  }

  void tapDownRight(TapDownDetails details) {
    print("DownRight");
    unityWidgetController.postMessage(
        'Player',
        'moveRightStart', '');
  }

  void tapUpRight(TapUpDetails details) {
    print("UpRight");
    unityWidgetController.postMessage(
        'Player',
        'moveRightEnd', '');
  }

  void jumpButtonPressed() {
    print("jump pressed");
    unityWidgetController.postMessage(
        'Player',
        'jump', '');
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this.unityWidgetController = controller;
  }
}
