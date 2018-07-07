import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoaderDialog.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Messagerializer',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  final String title = "Messagerialize";

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('com.diragi.1337/shell');
  bool enabled = false;
  String title = "Disabled";

  Future<Null> _runShellScript(bool val) async {
    bool status = val;
    String toggle = status ? 'disableM2' : 'enableM2';    
    try {
      status = await platform.invokeMethod(toggle);
    } on PlatformException catch (e) {
      print(e);
    }
    String stats = val ? "Disabled" : "Enabled";
    setState(() {
      enabled = !val;
      title = stats;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext ctx, AsyncSnapshot<SharedPreferences> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default: if (!snapshot.hasError) {
              return snapshot.data.getBool("welcome") != null
                  ? makeHomeScreen()
                  : LoaderDialog();
            } else {
              print("ah, shit");
            }
          }
        }
      
      )
    );
  }

  showDownloadingDialog() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => LoaderDialog()
    ));
  }

  makeHomeScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: () {
                  _runShellScript(enabled);
                },
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).accentColor),
                  child: ListTile(
                    title: Text(title),
                    trailing: Switch(
                      value: enabled,
                      onChanged: (e) {
                        _runShellScript(!e);
                      }
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text(
                    "This is pretty experimental software. I threw it together in a few hours. If you toggle the switch and nothing happens, kill messaging form recents and start it again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w200
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * 
 */
