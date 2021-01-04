import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rush/providers/AddressState.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:rush/router.dart';
import 'package:rush/screens/auth/login.dart';
import 'package:rush/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

enum LoginStatus { notSignIn, signIn }

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation animation,
      delayedAnimation,
      muchDelayAnimation,
      transfor,
      fadeAnimation;
  AnimationController animationController;
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  SharedPreferences sharedPreferences;

  /*
  Map<PermissionGroup, PermissionStatus> permissions;
  Map<PermissionGroup, PermissionStatus> permissionRequestResult;*/
  PermissionStatus permission;

  String accesstoken = "";

  /*Future<void> requestPermission() async {
    permissions = await PermissionHandler()
        .requestPermissions([PermissionGroup.location]);
  }*/

  Future getCredential() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.get('userid'));
    setState(() {
      accesstoken = sharedPreferences.getString("accesstoken");
      print(accesstoken);
    });
  }

  Future<void> initHistory() {
    final pickupState = Provider.of<PickupState>(context, listen: false);
    pickupState.requestDrive();
  }

  Future<void> initAddresses() {
    final addressState = Provider.of<AddressState>(context, listen: false);
    addressState.getAddresses();
  }

  @override
  void initState() {
    super.initState();
    getCredential();
    animationController = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    transfor = BorderRadiusTween(
            begin: BorderRadius.circular(125.0),
            end: BorderRadius.circular(0.0))
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease));
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
    new Timer(new Duration(seconds: 3), () {
      if (accesstoken != null) {
        initHistory();
        initAddresses();
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoute.homeScreen, (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), ModalRoute.withName('/login'));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: new Container(
              decoration: new BoxDecoration(color: splashBgColor),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: FadeTransition(
                        opacity: fadeAnimation,
                        child: Image.asset(
                          "assets/image/logo.png",
                          height: 100.0,
                        )),
                  ),
                  Container(
                    child: Text('7RUSH',style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    )),
                  )
                ],
              ),
            ),
          );
        });
  }
}