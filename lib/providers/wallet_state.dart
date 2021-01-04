import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rush/config.dart';
import 'package:rush/model/PlaceModel.dart';
import 'package:rush/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WalletState with ChangeNotifier {
  String balance;

  WalletState() {
    getWalletBalance();
  }

  Future<void> getWalletBalance() async {
    var url = Config.apiurl + "users/balance";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString('userid');
    final response = await http.post(url, body: {'userid':userid});
    var res = json.decode(response.body);
    if (res['success'] == true) {
      print(res);
      balance = res['data']['balance'];
      notifyListeners();
    } else {
      balance = 0.00.toString();
      notifyListeners();
    }
  }

  Future<void> updateWalletBalance(reference, amount, userid, status, rawjson, createdat) async {
    var url = Config.apiurl + "users/update_balance";
    final response = await http.post(url, body: {
      'userid':userid,
      'amount': amount,
      'reference': reference,
      'status': status,
      'rawjson':rawjson,
      'createdat': createdat
    });
    var res = json.decode(response.body);
    print(res);
    if (res['success'] == true) {
      balance = res['data']['new_balance'];
      notifyListeners();
    } else {
      balance = 0.00.toString();
      notifyListeners();
    }
  }

  void showInfoFlushbar(BuildContext context, message) {
    Flushbar(
      message: message,
      backgroundColor: redColor,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.white,
      ),
      leftBarIndicatorColor: Colors.red.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}