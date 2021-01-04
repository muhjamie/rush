import 'dart:convert';
import 'dart:io';
import 'package:rush/components/loading.dart';
import 'package:rush/components/validations.dart';
import 'package:rush/config.dart';
import 'package:rush/model/PlaceDetailModel.dart';
import 'package:rush/providers/AppState.dart';
import 'package:rush/providers/PlaceState.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rush/screens/address/address.dart';
import 'package:rush/screens/notifications/notifications.dart';
import 'package:rush/screens/settings/settings.dart';
import 'package:rush/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'details.dart';

class PickupScreen extends StatefulWidget {
  final PlaceState placeState;
  final String screenTitle;

  const PickupScreen({Key key, this.placeState, this.screenTitle}) : super(key: key);

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  PlaceState placeState;
  GlobalKey _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  var sessionToken = TimeOfDay.now().toString();
  var googleMapServices;
  bool autovalidate = false;
  Validations validations = new Validations();
  PlaceDetail _fromPlaceDetail;
  PlaceDetail _toPlaceDetail;
  int _stepNumber = 1;
  bool _isBusy = false;
  bool expanded = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> processPickup(context) async {
    var pickupState = Provider.of<PickupState>(context, listen: false);
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
    } else {
      setState(() {
        _isBusy = true;
      });
      form.save();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        //setState(() { _isBusy = true; });
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        var userid = sharedPreferences.getString('userid');
        var accesstoken = sharedPreferences.getString('accesstoken');
        var url = Config.apiurl + "pickup/start_pickup";

        try {
          var process = await http.post(url, body: {
            'userid': userid,
            'accesstoken': accesstoken,
            'pickup_address': pickupState.pickupLocation.text,
            'pickup_lat': pickupState.pickupLat.toString(),
            'pickup_lng': pickupState.pickupLng.toString(),
            'pickup_contact_name': pickupState.pickupName.text,
            'pickup_contact_phone': pickupState.pickupPhone.text.toString(),
            'pickup_landmark': pickupState.pickupLandmark.text,
            'pickup_time': pickupState.pickupDate.text,
            'dropoff_address': pickupState.dropoffLocation.text,
            'dropoff_lat': pickupState.dropoffLat.toString(),
            'dropoff_lng': pickupState.dropoffLng.toString(),
            'dropoff_contact_name': pickupState.dropoffName.text,
            'dropoff_contact_phone': pickupState.dropoffPhone.text,
            'dropoff_landmark': pickupState.dropoffLandmark.text,
            'dropoff_time': pickupState.dropoffDate.text,
          });

          print(process.body);
          final res = json.decode(process.body);
          if (res['success'] == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PickupDetails(
                      bookingId: res['data']['booking_id'].toString(),
                      pickupLocation: res['data']['pickup_address'],
                      dropoffLocation: res['data']['dropoff_address'],
                      amount: res['data']['cost'].toString(),
                      userid: userid,
                      duration: res['data']['duration'],
                      distance: res['data']['distance'],
                      discount: res['data']['discount'].toString(),
                      tax: res['data']['tax'].toString(),
                    ),
              ),
            );
            setState(() {
              _isBusy = false;
            });
          } else {
            setState(() {
              _isBusy = false;
              expanded = true;
            });
            pickupState.showInfoFlushbar(context, res['data']);
          }
        } catch (e) {
          print(e);
          setState(() {
            _isBusy = false;
          });
          pickupState.showInfoFlushbar(context, e.toString());
        }
      } else {
        pickupState.showInfoFlushbar(context, "No Internet Connection");
        setState(() {
          _isBusy = false;
        });
      }
    }
    setState(() {
      _isBusy = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isBusy;
    super.dispose();
  }

  willPopAction() {
    setState(() {
      _isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pickupState = Provider.of<PickupState>(context);
    final appState = Provider.of<AppState>(context);
    return WillPopScope(
      onWillPop: () {
        return willPopAction();
      },
      child: SafeArea(
        child: new Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Pickup and Delivery Form'),
            elevation: 0.0,
            actions: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen() ));
                  },
                  child: Icon(Icons.notifications_active),
                ),
                margin: EdgeInsets.only(right: 20),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen() ));
                  },
                  child: Icon(Icons.filter_list),
                ),
                margin: EdgeInsets.only(right: 20),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          body: Container(
            padding: EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                    children: <Widget>[
                      PickupForm(context),
                      SizedBox(height: 20),
                      DeliveryForm(context),
                      SizedBox(height: 20,),
                      ButtonTheme(
                        height: 50.0,
                        minWidth:
                        MediaQuery.of(context).size.width,
                        child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)
                          ),
                          elevation: 0.0,
                          color: primaryColor,
                          icon: new Text(''),
                          label: _isBusy ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: new AlwaysStoppedAnimation<Color>(whiteColor),
                            ),
                          ) : new Text('Continue', style: TextStyle(fontSize: 15, color: whiteColor)),
                          onPressed: () {
                            processPickup(context);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

  Widget PickupForm(BuildContext context) {
    final pickupState = Provider.of<PickupState>(context);
    return Container(
      child: Card(
        color: backgroundColor,
        elevation: 0.0,
        child: ExpansionTile(
            backgroundColor: backgroundColor,
            initiallyExpanded: true,
            leading: Icon(Icons.business_center),
            title: Text(
              "Pickup",
              style: new TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            children: <Widget>[
              SizedBox(height: 10,),
              TextFormField(
                readOnly: true,
                validator: validations.validateAddress,
                controller: pickupState.pickupLocation,
                style: TextStyle(fontSize: 13),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen(controller: pickupState.pickupLocation, form: 'pickup',)));
                },
                decoration: InputDecoration(
                  fillColor: primaryColor,
                  labelText: "Pickup Location",
                ),
              ),

              SizedBox(height: 20.0),
              TextFormField(
                validator: validations.validateName,
                controller: pickupState.pickupName,
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: "Sender's Name",
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                validator: validations.validateSenderPhone,
                controller: pickupState.pickupPhone,
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: "Sender's Phone",
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                validator: validations.validateDate,
                decoration: InputDecoration(
                  labelText: 'Pickup Date and Time',
                ),
                readOnly: false,
                controller: pickupState.pickupDate,
                style: TextStyle(fontSize: 13),
                onTap: () async {
                  pickupState.selectDate(context, pickupState.pickupDate);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pickup Location Landmark',
                ),
                readOnly: false,
                controller: pickupState.pickupLandmark,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
      ),
    );
  }

  Widget DeliveryForm(BuildContext context) {
    final pickupState = Provider.of<PickupState>(context);
    return SingleChildScrollView(
      child: Container(
        color: backgroundColor,
        child: ExpansionTile(
          leading: Icon(Icons.location_city),
          initiallyExpanded: true,
          title: Text(
            "Delivery",
            style: new TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          children: <Widget>[
            SizedBox(height: 20),
            TextFormField(
              readOnly: true,
              validator: validations.validateAddress,
              controller: pickupState.dropoffLocation,
              style: TextStyle(fontSize: 13),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen(controller: pickupState.dropoffLocation, form: 'dropoff',)));
              },
              decoration: InputDecoration(
                labelText: "Dropoff location",
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              validator: validations.validateReceiverName,
              controller: pickupState.dropoffName,
              style: TextStyle(fontSize: 13),
              decoration: InputDecoration(
                labelText: "Receiver's Name",
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              validator: validations.validateReceiverPhone,
              controller: pickupState.dropoffPhone,
              style: TextStyle(fontSize: 13),
              decoration: InputDecoration(
                labelText: "Receiver's Phone",
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Dropoff Location Landmark',
              ),
              readOnly: false,
              controller: pickupState.dropoffLandmark,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
