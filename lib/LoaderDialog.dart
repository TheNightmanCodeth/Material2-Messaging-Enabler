
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
            Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  strokeWidth: 10.0,
                  value: _progress
                ),
              ),
            ),
            Text('The small text'),
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
    String path = "/sdcard/Download/m2/m2_toggle.sh";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    await Dio().download("https://github.com/TheNightmanCodeth/Material2-Messaging-Enabler/raw/master/assets/m2_toggle.sh", path,
      onProgress: (rec, tot) {        
        setState(() {
          _progress = ((rec/tot)*100);
        }); 
      },
    );
    await prefs.setBool('welcome', true);
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (BuildContext c) => MyHomePage()
    ));
  }
}