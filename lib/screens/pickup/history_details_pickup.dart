import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush/components/ink_well_custom.dart';
import 'package:rush/config.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:rush/router.dart';
import 'package:rush/screens/pickup/pickup.dart';
import 'package:rush/theme/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookingHistoryDetailPickupScreen extends StatefulWidget {
  final String bookingId;
  final String pickupAddress;
  final String dropoffAddress;
  final String amount;
  final String distance;
  final String sender_name;
  final String sender_phone;
  final String pickup_landmark;
  final String receiver_name;
  final String receiver_phone;
  final String dropoff_landmark;
  final String status;
  final String rider_name;
  final String rider_phone;
  final String discount;
  final String tax;

  const BookingHistoryDetailPickupScreen({Key key, this.bookingId, this.pickupAddress, this.dropoffAddress, this.amount, this.distance, this.sender_name, this.sender_phone, this.pickup_landmark, this.receiver_name, this.receiver_phone, this.dropoff_landmark, this.status, this.rider_name, this.rider_phone, this.discount, this.tax}) : super(key: key);

  @override
  _BookingHistoryDetailPickupScreenState createState() => _BookingHistoryDetailPickupScreenState();
}

class _BookingHistoryDetailPickupScreenState extends State<BookingHistoryDetailPickupScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String yourReview;
  double ratingScore;

  @override
  void initState() {
    final pickupState = Provider.of<PickupState>(context, listen: false);
    pickupState.requestDrive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final pickupState = Provider.of<PickupState>(context, listen: false);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                PickupScreen()), (Route<dynamic> route) => false);
          },
        ),
        title: Text('Booking Details'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: InkWellCustom(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget?.rider_name != null ?
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed(AppRoute.driverDetailScreen);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    color: backgroundColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(70.0),
                          child:  SizedBox(
                            height: 70,
                            width: 70,
                            child: Hero(
                              tag: "avatar_profile",
                              child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: CachedNetworkImageProvider(
                                    "https://source.unsplash.com/300x300/?portrait",
                                  )
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: screenSize.width - 100,
                            padding: EdgeInsets.only(left: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text("Steve Bowen",style: textBoldBlack,),
                                    ),
                                    Text("08 Jan 2019 15:34",style: textStyle,),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                ),
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                ) : Container(height: 10),
                rideHistory(),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  color: backgroundColor,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Distance", style: textStyle,),
                            new Text(widget?.distance != null ? widget?.distance : '', style: textStyle),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Sender's Name", style: textStyle,),
                            new Text(widget?.sender_name != null ? widget?.sender_name : '', style: textStyle,),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Receiver's Name", style: textStyle,),
                            new Text(widget?.receiver_name != null ? widget?.receiver_name : '', style: textStyle,),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Sender's Phone", style: textStyle,),
                            new Text(widget?.sender_phone != null ? widget?.sender_phone : '', style: textStyle,),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Receiver's Phone", style: textStyle,),
                            new Text(widget?.receiver_phone != null ? widget?.receiver_phone : '', style: textStyle,),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Status", style: textStyle,),
                            new Builder(builder: (context) {
                              var status = '${widget?.status}';
                              return GestureDetector(
                                child: showStatus(status),
                                onTap: () => print(status),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 4.0, height: 30),
                new Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  color: backgroundColor,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Booking Cost", style: textStyle),
                            new Text((widget.amount) != null ? "\u{20A6}" + (widget?.amount) : '', style: textStyle,),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Discount", style: textStyle,),
                            new Text(widget?.discount != null ? "\u{20A6}" + widget?.discount : '', style: textStyle,),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Taxes (7.5%)", style: textStyle,),
                            new Text(widget?.tax != null ? "\u{20A6}" + widget?.tax : '', style: textStyle,),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text("Total Bill",
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            new Text(widget?.amount != null ? "\u{20A6}" + widget?.amount : '',
                                style: TextStyle(
                                    color: blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                if(widget?.status == '2') Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new ButtonTheme(
                      height: 40.0,
                      minWidth:
                      MediaQuery.of(context)
                          .size
                          .width - 300,
                      child: RaisedButton.icon(
                        shape:
                        new RoundedRectangleBorder(
                            borderRadius:
                            new BorderRadius
                                .circular(
                                3.0)),
                        elevation: 20.0,
                        color: greenColor,
                        icon: new Text(''),
                        label: new Text('Mark as complete'.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: whiteColor)),
                        onPressed: () {
                          markAsCompleted(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rideHistory(){
    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(15.0),
      color: backgroundColor,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(color: Colors.grey[200], width: 1.0),
          color: backgroundColor,
        ),
        child: Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.my_location, color: greenColor,),
                    Container(
                      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      height: 25,
                      width: 1.0,
                      color: Colors.grey,
                    ),
                    Icon(Icons.location_on, color: redColor,)
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget?.pickupAddress != null ? widget?.pickupAddress : '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(widget?.dropoffAddress != null ? widget?.dropoffAddress : '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showStatusx(String status) {
    //print("------" + status);
    var statuses = "";
    return Text(
      status.toUpperCase(),
      style: TextStyle(
          color: yellow, fontWeight: FontWeight.bold, fontSize: 13.0),
    );
  }


  Widget showStatus(String status) {
    Map statuses = {'0': "Pending", '1': "Pending", '2': "In Progress", "3": "Completed"};

    return Text(
      statuses[status].toUpperCase(),
      style: TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13.0),
    );
  }

  Future<void> markAsCompleted(context) async {
    var requestId = widget?.bookingId;
    final pickupState = Provider.of<PickupState>(context, listen: false);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString('userid');
    var accesstoken = sharedPreferences.getString('accesstoken');
    var url =  Config.apiurl + "pickup/complete_request";
    print(requestId);
    print('------------------');
    var process = await http.post(url, body: {
      'userid': userid,
      'accesstoken': accesstoken,
      'request_id': requestId
    });
    print(process.body);
    print(json.decode(process.body));
    final res = json.decode(process.body);
    if (res['success'] == true) {
      print(res['data']);
      pickupState.requestDrive();
      Navigator.pop(context);
    }
  }
}