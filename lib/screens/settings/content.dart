import 'package:flutter/material.dart';
import 'package:rush/theme/style.dart';

class ContentsScreen extends StatelessWidget {

  final String title;
  final String content;

  const ContentsScreen({Key key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: whiteColor)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Text(content, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, height: 2.0, wordSpacing: 3.0),),
      ),
    );
  }
}
