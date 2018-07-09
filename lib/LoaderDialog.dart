import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';

import 'main.dart';

class LoaderDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoaderDialogState();
}

class _LoaderDialogState extends State<LoaderDialog> {
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    getScript(context);
    return SimpleDialog(
      children: <Widget>[
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Text('Setup'),
            ),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.blueGrey[100],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                value: _progress
              ),
            ),
            Text('Downloading toggle script...',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ],
    );
  }

  getScript(BuildContext ctx) async {
    // * Get permissions
    bool writePermission = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    bool readPermission = await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    if (writePermission && readPermission) print('Permissions gained');
    
    // * Get a SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String path = "/sdcard/Download/m2/m2_toggle.sh";

    //* Make sure the path exists and download the script from my github
    await Directory("/sdcard/Download/m2/").create(recursive: true);
    await Dio().download("https://github.com/TheNightmanCodeth/Material2-Messaging-Enabler/raw/master/assets/m2_toggle.sh", path,
      onProgress: (rec, tot) {        
        setState(() {
          _progress = ((rec/tot)*10);
        }); 
      },
    );
    //* The file is downloaded and the path exists, set welcome flag and go to app
    await prefs.setBool('welcome', true);
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (BuildContext c) => MyHomePage()
    ));
  }
}