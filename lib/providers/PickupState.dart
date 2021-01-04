import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rush/config.dart';
import 'package:flutter/material.dart';
import 'package:rush/model/PlaceModel.dart';
import 'package:rush/model/booking_model.dart';
import 'package:rush/providers/PlaceState.dart';
import 'package:rush/providers/AppState.dart';
import 'package:rush/screens/pickup/details.dart';
import 'package:rush/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PickupState extends AppState {
  String _name;
  String _phone;
  PlaceState placeState;
  TextEditingController pickupLocation = TextEditingController();
  TextEditingController pickupName = TextEditingController();
  TextEditingController pickupPhone = TextEditingController();
  TextEditingController pickupDate = TextEditingController();
  TextEditingController pickupLandmark = TextEditingController();
  TextEditingController pickupStreetName = TextEditingController();
  TextEditingController pickupHouseNumber = TextEditingController();
  TextEditingController deliveryType = TextEditingController();
  double pickupLat;
  double pickupLng;
  TextEditingValue packageSize = TextEditingValue();

  TextEditingController dropoffLocation = TextEditingController();
  TextEditingController dropoffName = TextEditingController();
  TextEditingController dropoffPhone = TextEditingController();
  TextEditingController dropoffDate = TextEditingController();
  TextEditingController dropoffLandmark = TextEditingController();
  TextEditingController dropoffHouseNumber = TextEditingController();
  double dropoffLat;
  double dropoffLng;

  DateTime _selectedDate = DateTime.now();
  String get name => _name;
  String get phone => _phone;
  DateTime get selectedDate => _selectedDate;
  String selectedDeliveryType;
  String packageSizeSelect;
  String fromPlaceId;
  String toPlaceId;
  double fromLat;
  double fromLng;
  double toLat;
  double toLng;
  LatLng _initialPosition;
  Position currentLocation;
  String _placemark;
  final Geolocator _locationService = Geolocator();
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  List packages = [];
  List history;

  set setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  PickupState() {
    _updatePickupForm();
    requestDrive();
  }

  Future<void> _updatePickupForm() async {
    _getUserLocation();
    _getName();
    _getPhone();
    _getDate();
    notifyListeners();
  }

  Future<void> _getUserLocation() async {
    try {
      currentLocation = await _locationService.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      print(currentLocation);
      List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(currentLocation?.latitude, currentLocation?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        _placemark = pos.name + ', ' + pos.thoroughfare;
        placeState?.formLocation?.name = _placemark;
        placeState?.getCurrentLocation(Place(
            name: _placemark,
            formattedAddress: "",
            lat: currentLocation?.latitude,
            lng: currentLocation?.longitude
        ));
        pickupLat = currentLocation?.latitude;
        pickupLng = currentLocation?.longitude;
        pickupLocation.text = _placemark;
        notifyListeners();
      }
    } catch(e) {
      print(e);
    }
  }

  Future<List<BookingHistoryModel>> requestDrive() async {
    try {
      SharedPreferences p = await SharedPreferences.getInstance();
      var userid = p.getString('userid');
      String url = "http://7rush.ng/app/apipro/bookinghistory.php?userid=" + userid ;
      final response = await http.get(url);
      BookingHistoryModelFromMap(response.body);
      history = json.decode(response.body);
      print(history);
      notifyListeners();
    } catch(e) {
      print(e);
    }
    notifyListeners();
  }

  void resetState() {
    _getUserLocation();
    _getDate();
    _getName();
    _getPhone();
    dropoffLocation.text = '';
    dropoffName.text = '';
    dropoffPhone.text = '';
    dropoffLandmark.text = '';
    notifyListeners();
  }

  Future<String> _getName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    _name = sharedPreferences.getString("name");
    pickupName.text = _name;
    notifyListeners();
  }

  Future<String> _getPhone() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    _phone = sharedPreferences.getString("phone");
    pickupPhone.text = _phone;
    notifyListeners();
  }

  void _getDate() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd H:m:a');
    final String formatted = formatter.format(_selectedDate);
    pickupDate.text = formatted;
    notifyListeners();
  }

  Future<Null> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
        initialDatePickerMode: DatePickerMode.day,
        errorInvalidText: 'Error'
    );
    if(picked != null && picked != selectedDate) _selectedDate = picked;
    controller.text = picked.toString();
    notifyListeners();
  }


  Future <void> process_pickup(context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString('userid');
    var accesstoken = sharedPreferences.getString('accesstoken');
    print(accesstoken);
    var url = Config.apiurl + "pickup/start_pickup";

    try {
      var process = await http.post(url, body: {
        'userid': userid,
        'accesstoken': accesstoken,
        'pickup_address': pickupLocation.text,
        'pickup_contact_name': pickupName.text,
        'pickup_contact_phone': pickupPhone.text.toString(),
        'pickup_landmark': pickupLandmark.text,
        'pickup_time': pickupDate.text,
        'dropoff_address': dropoffLocation.text,
        'dropoff_contact_name': dropoffName.text,
        'dropoff_contact_phone': dropoffPhone.text,
        'dropoff_landmark': dropoffLandmark.text,
        'dropoff_time': dropoffDate.text,

      });
      print(json.decode(process.body));
      final res = json.decode(process.body);
      if(res['success'] == true) {
        notifyListeners();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PickupDetails(
              pickupLocation: res['data']['pickup_address'],
              dropoffLocation: res['data']['dropoff_address'],
              amount: res['data']['cost'],
              userid: userid,
              duration: res['data']['duration'],
              distance: res['data']['distance'],
            ),
          ),
        );
      } else {
        showInfoFlushbar(context, res['data']);
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
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