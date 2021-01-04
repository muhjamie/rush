import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rush/config.dart';
import 'package:rush/model/PlaceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileState with ChangeNotifier {
  String userid;
  String name;
  String phone;
  String email;
  String imageUrl;

  TextEditingController nameText = TextEditingController();
  TextEditingController phoneText = TextEditingController();
  TextEditingController emailText = TextEditingController();

  WalletState() {
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userid = sharedPreferences.getString('userid');
    name = sharedPreferences.getString('name');
    phone = sharedPreferences.getString('phone');
    email = sharedPreferences.getString('email');
    imageUrl = sharedPreferences.getString('imageUrl');
    notifyListeners();
  }
}