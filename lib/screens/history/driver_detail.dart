import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rush/theme/style.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class DriverDetailScreen extends StatefulWidget {
  final String riderName;
  final String riderPhone;
  final int riderCompleted;
  final int riderCancelled;
  final int riderInProgress;

  const DriverDetailScreen({Key key, this.riderName, this.riderPhone, this.riderCompleted, this.riderCancelled, this.riderInProgress}) : super(key: key);

  @override
  _DriverDetailScreenState createState() => _DriverDetailScreenState();
}

class _DriverDetailScreenState extends State<DriverDetailScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Rider Detail",
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              color: whiteColor,
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
                            backgroundImage: AssetImage(
                              "assets/image/user.png",
                            )
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(widget?.riderName,style: textBoldBlack,),
                        ),
                        Text(widget?.riderPhone,style: textStyle,),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              UrlLauncher.launch('tel:+${widget?.riderPhone}');
                            },
                            child: Icon(Icons.phone),
                          )
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  itemInfo1(icon: Icons.star, value: widget?.riderCompleted.toString(), title: 'Completed'),
                  itemInfo1(icon: Icons.favorite, value: widget?.riderInProgress.toString(), title: 'In Progress'),
                  itemInfo1(icon: Icons.calendar_today, value: widget?.riderCancelled.toString(), title: 'Cancelled'),

                ],
              ),
            ),
            //info2(),
          ],
        ),
      ),
    );
  }

  Widget itemInfo1({IconData icon, String value, String title}){
    final screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0),
      width: (screenSize.width-70)/3,
      height: 70,
      decoration: BoxDecoration(
          border: Border.all(
              color: greyColor2,
              width: 1.0
          ),
          borderRadius: BorderRadius.circular(3.0)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: greyColor2
            ),
            child: Text(title, style: textGreyBold,),
          ),
          SizedBox(height: 2.0,),
          Text(value ?? '',
            style: TextStyle(
                color: blackColor,
                fontSize: 20
            ),
          ),
        ],
      ),
    );
  }

  Widget info2(){
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 40),
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          border: Border.all(
              color: greyColor2,
              width: 1.0
          ),
          borderRadius: BorderRadius.circular(3.0)
      ),
      child: Column(
        children: <Widget>[
          TextField(
            style: TextStyle(color: blackColor, fontSize: 15),
            decoration: InputDecoration(
                enabled: false,
                fillColor: whiteColor,
                labelStyle: TextStyle(color: greyColor),
                hintStyle: TextStyle(color: Colors.white),
                counterStyle: textStyle,
                labelText: "Member since",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))
            ),
            controller:
            TextEditingController.fromValue(
              TextEditingValue(
                text: "16.06.2018",
              ),
            ),
          ),
          TextField(
            style: TextStyle(color: blackColor, fontSize: 15),
            decoration: InputDecoration(
                enabled: false,
                fillColor: whiteColor,
                labelStyle: TextStyle(color: greyColor),
                hintStyle: TextStyle(color: Colors.white),
                counterStyle: textStyle,
                labelText: "Car Type",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))
            ),
            controller:
            TextEditingController.fromValue(
              TextEditingValue(
                text: "Van",
              ),
            ),
          ),
          TextField(
            style: TextStyle(color: blackColor, fontSize: 15),
            decoration: InputDecoration(
                enabled: false,
                fillColor: whiteColor,
                labelStyle: TextStyle(color: greyColor),
                hintStyle: TextStyle(color: Colors.white),
                counterStyle: textStyle,
                labelText: "Plae Number",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))
            ),
            controller:
            TextEditingController.fromValue(
              TextEditingValue(
                text: "HS785K",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
