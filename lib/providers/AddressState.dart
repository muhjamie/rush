import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:rush/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddressState extends ChangeNotifier {
  String address;
  String label;
  String lat;
  String lng;
  String placeId;
  List addresses;
  SharedPreferences sharedPreferences;

  AddressState() {
    getAddresses();
  }

  Future getAddresses() async {
    try{
      sharedPreferences = await SharedPreferences.getInstance();
      var userid = sharedPreferences.getString('userid');
      var accesstoken = sharedPreferences.getString('accesstoken');
      var url = Config.apiurl + "users/get_addresses?userid=" + userid + "&accesstoken=" + accesstoken;
      final response = await http.get(url);
      var data = json.decode(response.body);
      print(data);
      if(data['success'] == true) {
        addresses = data['data']['addresses'];
        print(addresses);
        notifyListeners();
      } else {
        addresses = [];
        notifyListeners();
      }
    } catch(e) {
      print(e);
      addresses = [];
      notifyListeners();
    }
  }
}