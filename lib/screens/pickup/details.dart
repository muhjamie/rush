import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush/components/loading.dart';
import 'package:rush/config.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:rush/providers/notifications_state.dart';
import 'package:rush/providers/wallet_state.dart';
import 'package:rush/screens/pickup/history_details_pickup.dart';
import 'package:rush/theme/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PickupDetails extends StatefulWidget {
  final String bookingId;
  final String pickupLocation;
  final String dropoffLocation;
  final String amount;
  final String userid;
  final String duration;
  final String distance;
  final String discount;
  final String tax;

  const PickupDetails({Key key, this.pickupLocation, this.dropoffLocation, this.amount, this.userid, this.duration, this.distance, this.bookingId, this.discount, this.tax}) : super(key: key);
  @override
  _PickupDetailsState createState() => _PickupDetailsState();
}

class _PickupDetailsState extends State<PickupDetails> {
  bool _isBusy;

  Future<void> makeRequest(context) async {
    setState(() => _isBusy = true);
    var url = Config.apiurl + "pickup/make_request";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString('userid');
    var accesstoken = sharedPreferences.getString('accesstoken');
    var response = await http.post(url, body: {
      "userid": userid,
      "accesscode": accesstoken.trim(),
      "booking_id": widget?.bookingId,
      "amount": widget?.amount,
    });
    print(response.body.trim());
    final res = json.decode(response.body);
    print(res);
    if (res['success'] == true) {
      processNotify();
      processWallet();
      final pickupState = Provider.of<PickupState>(context, listen: false);
      pickupState.requestDrive().whenComplete(() {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => BookingHistoryDetailPickupScreen(
              bookingId: widget?.bookingId,
              distance: res['data']['distance'],
              pickupAddress: res['data']['pickup'],
              dropoffAddress: res['data']['dropoff'],
              amount: widget?.amount,
              sender_name: res['data']['sender_name'],
              sender_phone: res['data']['sender_phone'],
              pickup_landmark: res['data']['pickup_landmark'],
              receiver_name: res['data']['receiver_name'],
              receiver_phone: res['data']['receiver_phone'],
              dropoff_landmark: res['data']['receiver_landmark'],
              status: res['data']['status'],
              tax: widget?.tax,
              discount: widget?.discount,
            ))
        );
        setState(() => _isBusy = false);
      });
    } else {
      setState(() => _isBusy = false);
      showInfoFlushbar(context, res['data']);
    }
    setState(() => _isBusy = false);
  }

  processNotify() {
    final notificationsStates = Provider.of<NotificationsState>(context, listen: false);
    notificationsStates.getNotifications();
  }

  processWallet() {
    final walletState = Provider.of<WalletState>(context, listen: false);
    walletState.getWalletBalance();
  }

  @override
  void initState() {
    _isBusy = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        elevation: 0.0,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(top: 00.0, left: 0.0, right: 0.0),
            child: Container(
              height: MediaQuery.of(context).size.height - 355,
              padding: EdgeInsets.all(20.0),
              width: 400,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),

              child: Card(
                color: backgroundColor,
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.my_location, size: 15,),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Text(widget?.pickupLocation, style:
                            TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300
                            ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30, child: Divider(),),
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_city, size: 15,),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Text(widget?.dropoffLocation, style:
                            TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300
                            ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30, child: Divider(),),
                      Row(
                        children: <Widget>[
                          Icon(Icons.compare_arrows, size: 15,),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Text(widget?.distance, style:
                            TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300
                            ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 30, child: Divider(),),
                      Row(
                        children: <Widget>[
                          Text('\u{20A6}', style: TextStyle(fontSize: 15, color: primaryColor),),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Text(widget?.amount.toString(), style:
                            TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300
                            ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40,),
                      ButtonTheme(
                        height: 40.0,
                        minWidth:
                        MediaQuery.of(context)
                            .size
                            .width,
                        child: RaisedButton.icon(
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                              new BorderRadius
                                  .circular(
                                  3.0)),
                          elevation: 1.0,
                          color: primaryColor,
                          icon: new Text(''),
                          label: _isBusy ? SizedBox(
                            height: 20,
                            width: 20,
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: new AlwaysStoppedAnimation<Color>(whiteColor),
                              ),
                            ),
                          ) : new Text('Make Request',
                              style: TextStyle(fontSize: 15, color: whiteColor)),
                          onPressed: () {
                            if(_isBusy == false) makeRequest(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }

  Widget showStatus(String status) {
    Map statuses = {'0': "Pending", '1': "In Progress", '2': "Completed"};

    return Text(
      statuses[status].toUpperCase(),
      style: TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13.0),
    );
  }

  void showInfoFlushbar(BuildContext context, message) {
    Flushbar(
      message: message,
      backgroundColor: redColor,
      icon: Icon(
        Icons.info_outline,
        size: 28,
        color: Colors.red.shade300,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
