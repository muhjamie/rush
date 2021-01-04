import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush/model/address_model.dart';
import 'package:rush/model/notifications_model.dart';
import 'package:rush/providers/notifications_state.dart';
import 'package:rush/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Future<Addresses> futureAddresses;
  SharedPreferences sharedPreferences;
  List notifications;
  Future<Notifications> futureNotifications;
  @override
  Widget build(BuildContext context) {
    final notificationsState = Provider.of<NotificationsState>(context);
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          title: Container(
            child: Text('Notifications',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: whiteColor
              ),
            ),
          ),
        ),
        body: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20, bottom: 20),
          separatorBuilder:(_,int i){
            return SizedBox(height: 10);
          },
          itemCount: notificationsState?.notifications == null ? 0 : notificationsState?.notifications?.length,
          itemBuilder: (BuildContext context, index) {
            return GestureDetector(
              onTap: () async {
                setState(() {
                  //_placemark = addressState?.addresses[index]['address'];
                });
                //widget?.controller?.text = addressState?.addresses[index]['address'];
                //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => PickupScreen()), ModalRoute.withName('/pickupScreen'));
              },
              child: Material(
                elevation: 1.0,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(notificationsState?.notifications[index]['title'], style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(notificationsState?.notifications[index]['notification'])
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}