import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/pages/home/home.dart';
import 'package:tritek_lms/pages/login_signup/capture.dart';


class BlurryDialog extends StatelessWidget {

  String title;
  String content;
  
  CameraDescription cameraDescription;

  BlurryDialog(this.title, this.content, );
  TextStyle textStyle = TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child:  AlertDialog(
      title: new Text(title,style: textStyle,),
      content: new Text(content, style: textStyle,),
      actions: <Widget>[
        new FlatButton(
          child: Text("No"),
          onPressed: () {
            Home();
          },
        ),
        new FlatButton(
          child: new Text("Yes"),
           onPressed: () {
            Capture(cameraDescription: cameraDescription);
          },
        ),
        
      ],
      ));
  }
}