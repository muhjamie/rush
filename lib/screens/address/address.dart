import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush/model/address_model.dart';
import 'package:rush/providers/AddressState.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:rush/providers/PlaceState.dart';
import 'package:rush/screens/address/create_address.dart';
import 'package:rush/screens/pickup/pickup.dart';
import 'package:rush/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  final PlaceState placeState;
  final TextEditingController controller;
  final PickupState pickupState;
  final String form;

  const AddressScreen({Key key, this.placeState, this.controller, this.pickupState, this.form}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Future<Addresses> futureAddresses;
  SharedPreferences sharedPreferences;
  List addresses;
  bool _isBusy;
  String _placemark = '';

  @override
  Widget build(BuildContext context) {
    final addressState = Provider.of<AddressState>(context);
    final pickupState = Provider.of<PickupState>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Container(
          child: Text('Saved addresses',
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
        itemCount: addressState?.addresses == null ? 0 : addressState?.addresses?.length,
        itemBuilder: (BuildContext context, index) {
          return GestureDetector(
            onTap: () async {
              setState(() {
                _placemark = addressState?.addresses[index]['address'];
              });

              widget?.controller?.text = addressState?.addresses[index]['address'];
              print(widget?.form);
              if(widget?.form == 'pickup') {
                pickupState?.pickupLat = double.parse(addressState?.addresses[index]['lat']);
                pickupState?.pickupLng = double.parse(addressState?.addresses[index]['lng']);
              }

              if(widget?.form == 'dropoff') {
                pickupState?.dropoffLat = double.parse(addressState?.addresses[index]['lat']);
                pickupState?.dropoffLng = double.parse(addressState?.addresses[index]['lng']);
              }
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => PickupScreen()), ModalRoute.withName('/pickupScreen'));
            },
            child: Material(
              elevation: 1.0,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(addressState?.addresses[index]['label'], 
                    style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(addressState?.addresses[index]['address'])
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        autofocus: true,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateAddressScreen()),
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: whiteColor,),
      )
    );
  }
}