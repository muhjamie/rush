import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:rush/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationsState extends ChangeNotifier {
  List notifications;
  SharedPreferences sharedPreferences;

  NotificationsState() {
    getNotifications();
  }

  Future getNotifications() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString('userid');
    var url = Config.apiurl + "users/get_notifications?userid=" + userid;
    final response = await http.get(url);
    var result = json.decode(response.body);
    notifications = result['data']['notifications'];
    notifyListeners();
  }
}