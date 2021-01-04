import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rush/theme/style.dart';

class LoadingBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bodyProgress = Container(
      color: backgroundColor,
      child: SpinKitRipple(
        color: transparentColor,
        size: 100.0,
      ),
    );
    return bodyProgress;
  }
}
