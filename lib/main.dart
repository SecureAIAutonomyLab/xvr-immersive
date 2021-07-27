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

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.scene});

  String title;
  int scene;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'AR Face Object 1', scene: 0),
  CustomPopupMenu(title: 'AR Face Object 2', scene: 1),
  CustomPopupMenu(title: 'Spider', scene: 2),
];

class _UnityDemoScreenState extends State<UnityDemoScreen>{
  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  UnityWidgetController unityWidgetController;
  CustomPopupMenu selectedChoice = choices[0];

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Unity in Flutter"),
        actions: <Widget>[
          PopupMenuButton<CustomPopupMenu>(
            elevation: 3.2,
            initialValue: selectedChoice,
            onCanceled: () {
              print('You have not chosen anything');
            },
            tooltip: 'This is tooltip',
            onSelected: selectOption,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () {
            return;
          },
          child: Container(
            color: Colors.black,
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
            ),
          ),
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this.unityWidgetController = controller;
  }

  void selectOption(CustomPopupMenu choice) {
    setState(() {
      selectedChoice = choice;
    });
    unityWidgetController.postMessage(
      'GameManager',
      'LoadGameScene',
      choice.scene.toString(),
    );
  }
}
