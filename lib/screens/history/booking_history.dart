import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rush/model/booking_model.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:rush/screens/history/history_detail.dart';
import 'package:rush/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isBusy = false;
  @override
  void initState() {
    super.initState();
  }

  Future getRequests() async {
    try {
      SharedPreferences p = await SharedPreferences.getInstance();
      var userid = p.getString('userid');
      String url = "http://7rush.ng/app/apipro/bookinghistory.php?userid=" + userid ;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load requests');
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pickupState = Provider.of<PickupState>(context, listen: true);
    pickupState.requestDrive();
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Booking History'),
          /*actions: <Widget>[
            IconButton(
              tooltip: 'Refresh',
              icon: Icon(Icons.refresh),
              onPressed: null,
            )
          ],*/
        ),
        body: _isBusy ? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: new AlwaysStoppedAnimation<Color>(whiteColor),
          ),
        ) : pickupState?.history == null ? Center(
          child: Image.asset('assets/image/empty_state_trash_300.png', height: 150,),
        ) : ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20, bottom: 20),
            separatorBuilder:(_,int i){
              return SizedBox(height: 20);
            },
            itemCount: pickupState?.history == null ? 0 : pickupState.history.length,
            itemBuilder: (BuildContext context, index) {
              final BookingHistoryModel bookingHistory = BookingHistoryModel.fromMap(pickupState.history[index]);
              final screenSize = MediaQuery.of(context).size;
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BookingHistoryDetailScreen(
                          bookingId: pickupState.history[index]['rr_id'],
                          distance: pickupState.history[index]['rr_distance'],
                          pickupAddress: pickupState.history[index]['rr_from'],
                          dropoffAddress: pickupState.history[index]['rr_todestination'],
                          amount: pickupState.history[index]['rr_tripfare'],
                          sender_name: pickupState.history[index]['rr_pickup_contact_name'],
                          sender_phone: pickupState.history[index]['rr_pickup_contact_phone'],
                          pickup_landmark: pickupState.history[index]['rr_pickup_contact_phone'],
                          receiver_name: pickupState.history[index]['rr_dropoff_contact_name'],
                          receiver_phone: pickupState.history[index]['rr_dropoff_contact_phone'],
                          dropoff_landmark: pickupState.history[index]['rr_dropoff_landmark'],
                          status: pickupState.history[index]['rr_tripstatus'],
                          tax: pickupState.history[index]['rr_tax'],
                          discount: pickupState.history[index]['rr_discount'],
                          rider_id: pickupState.history[index]['rr_driverid'],
                        ),
                  ));
                },
                child: Material(
                  elevation: 0.00,
                  borderRadius: BorderRadius.circular(3.0),
                  color: whiteColor,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: whiteColor
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${bookingHistory.rrTimeinitiated}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Builder(builder: (context) {
                              var status =
                                  '${bookingHistory.rrTripstatus}';
                              return showStatus(status);
                            })
                          ],
                        ),
                        Divider(),
                        Container(
                          height: 135,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.my_location,
                                      color: greenColor,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 18.0, bottom: 5.0),
                                      height: 13,
                                      width: 1.0,
                                      color: Colors.grey,
                                    ),
                                    Text(''),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      height: 13,
                                      width: 1.0,
                                      color: Colors.grey,
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      color: redColor,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${bookingHistory.rrFrom}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '${bookingHistory.rrTodestination}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
        )
    );
  }

  Widget showStatus(String status) {
    Map statuses = {'0': "Pending", '1': "Pending", '2': "In Progress", '3':'Completed', '4': 'Cancelled'};

    return Text(
      statuses[status].toUpperCase(),
      style: TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13.0),
    );
  }
}