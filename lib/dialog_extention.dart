import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension MyDialogh on BuildContext {
  Future<void> showMyAlertDialog(
      {required String title, required String description}) async {
    return showDialog<void>(
      context: this,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description, maxLines: 5,),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
