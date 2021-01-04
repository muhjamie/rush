import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rush/model/PlaceModel.dart';
import 'package:rush/config.dart';

class PlaceState with ChangeNotifier {
  StreamController<Place> locationController = StreamController<Place>.broadcast();
  Place locationSelect;
  Place formLocation;
  Place toLocation;
  String distance;
  String duration;
  List<Place> listPlace;

  Stream get placeStream => locationController.stream;

  Future<List<Place>> search(String query) async {
    String url = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=${Config.apiKey}&language=${Config.language}&region=${Config.region}&query="+Uri.encodeQueryComponent(query);//Uri.encodeQueryComponent(query)
    print(url);
    Response response = await Dio().get(url);
    print(Place.parseLocationList(response.data));
    listPlace = Place.parseLocationList(response.data);
    notifyListeners();
    return listPlace;
  }

  void locationSelected(Place location) {
    locationController.sink.add(location);
  }

  Future<void> selectLocation(Place location) async {
    notifyListeners();
    locationSelect = location;
    return locationSelect;
  }

  Future<void> getCurrentLocation(Place location) async {
    notifyListeners();
    formLocation = location;
    return formLocation;
  }

  /*Future<void> getPickupLocation(Place location) async {
    notifyListeners();
    pickupLocation = location;
    return pickupLocation;
  }*/

  Future<void> setDistance(String distanceText) {
    notifyListeners();
    distance = distanceText;
  }

  @override
  void dispose() {
    locationController.close();
    super.dispose();
  }
}