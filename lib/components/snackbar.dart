import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rush/theme/style.dart';

class ShowSnackBar extends StatelessWidget {
  final String message;

  const ShowSnackBar({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flushbar(
      message: message,
      backgroundColor: redColor,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.red.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
