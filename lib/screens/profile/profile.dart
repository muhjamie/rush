import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush/model/profile_model.dart';
import 'package:rush/providers/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_profile.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = Provider.of<ProfileState>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.mode_edit),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return EditProfile();
                  },
                ));
              },
            ),
            SizedBox(width: 10),
          ],
        ),
        backgroundColor: backgroundColor,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: Container(
              color: backgroundColor,
              child: Column(
                children: <Widget>[
                 /* Center(
                    child: Stack(
                      children: <Widget>[
                        *//*Material(
                          elevation: 10.0,
                          color: backgroundColor,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: SizedBox(
                              height: 150,
                              width: 150,
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
                        ),*//*
                        *//*Positioned(
                          bottom: 10.0,
                          left: 25.0,
                          height: 15.0,
                          width: 15.0,
                          child: Container(
                            width: 15.0,
                            height: 15.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: greenColor,
                                border: Border.all(
                                    color: Colors.white, width: 2.0)),
                          ),
                        ),*//*
                      ],
                    ),
                  ),*/

                  /*Container(
                    padding: EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          profileState.name,
                          style: TextStyle( color: blackColor,fontSize: 25.0),
                        ),
                        Text(
                          "Customer",
                          style: TextStyle( color: blackColor, fontSize: 13.0),
                        ),
                      ],
                    ),
                  ),*/
                  SizedBox(height: 20),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border(
                                  bottom: BorderSide(width: 1.0,color: appTheme?.backgroundColor)
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Name',style: textStyle,),
                              Text(profileState.name,style: textGrey,)
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border(
                                  bottom: BorderSide(width: 1.0,color: appTheme?.backgroundColor)
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Phone Number',style: textStyle,),
                              Text(profileState.phone,style: textGrey,)
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border(
                                  bottom: BorderSide(width: 1.0,color: appTheme?.backgroundColor)
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Email',style: textStyle,),
                              Text(profileState.email,style: textGrey,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
