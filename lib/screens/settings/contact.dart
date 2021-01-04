import 'package:flutter/material.dart';
import 'package:rush/theme/style.dart';

class ContactScreen extends StatelessWidget {
  final String title;

  const ContactScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Contact us'),
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50,),
            Image.asset('assets/image/logo.png', height: 200),
            Container(
              child: Text('Connect with us'),
            ),
            SizedBox(height: 15,),
            Container(
              child: Text('hello@7labs.ng', style: TextStyle(fontWeight: FontWeight.bold),),
            )
          ],
        ),
      ),
    ));
  }
}
