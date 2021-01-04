import 'dart:async';
import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rush/components/ink_well_custom.dart';
import 'package:rush/components/validations.dart';
import 'package:rush/components/loading.dart';
import 'package:rush/config.dart';
import 'package:rush/providers/AddressState.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:rush/router.dart';
import 'package:rush/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  bool _isLoading = false;
  Validations validations = new Validations();
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();

//  Map<PermissionGroup, PermissionStatus> permissions;
//  Map<PermissionGroup, PermissionStatus> permissionRequestResult;
  PermissionStatus permission;

  process_login(context) {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      _login(context);
    }
  }

  Future savePref(
      {String userid,
      String accesstoken,
      String phone,
      String name,
      String email,
      String usertype}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("userid", userid);
    preferences.setString("accesstoken", accesstoken);
    preferences.setString("phone", phone);
    preferences.setString("name", name);
    preferences.setString("email", email);
    preferences.setString("usertype", usertype);
  }

  Future _login(context) async {
    setState(() => _isLoading = true);

    // SERVER LOGIN API URL
    var url = Config.apiurl + 'auth/login';
    String emailText = _controllerEmail.text;
    String passwordText = _controllerPassword.text;
    final response = await http
        .post(url, body: {"email": emailText, "password": passwordText});
    final res = json.decode(response.body);
    print(res);

    if (res['success'] == true) {
      savePref(
          userid: res['data']['userid'],
          accesstoken: res['data']['accesstoken'],
          phone: res['data']['phone'],
          name: res['data']['name'],
          email: res['data']['email'],
          usertype: res['data']['usertype']);
      setState(() => _loginStatus = LoginStatus.signIn);
      initHistory();
      initAddresses();
      Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoute.homeScreen, (Route<dynamic> route) => false);
    } else {
      showInfoFlushbar(context, res['data']);
    }

    setState(() => _isLoading = false);
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
  }

  @override
  Widget build(BuildContext context) {
    // if (_loginStatus == LoginStatus.notSignIn) {
    return _isLoading
        ? LoadingBuilder()
        : Scaffold(
            body: SingleChildScrollView(
                child: InkWellCustom(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(children: <Widget>[
                      Container(
                        height: 250.0,
                        width: double.infinity,
                        color: Colors.blue,
                      ),
                      Positioned(
                        bottom: 450.0,
                        right: 100.0,
                        child: Container(
                          height: 400.0,
                          width: 400.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200.0),
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 500.0,
                        left: 150.0,
                        child: Container(
                            height: 300.0,
                            width: 300.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150.0),
                                color: Colors.blue.withOpacity(0.5))),
                      ),
                      new Padding(
                          padding: EdgeInsets.fromLTRB(32.0, 150.0, 32.0, 0.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: double.infinity,
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                      child: new Material(
                                    borderRadius: BorderRadius.circular(7.0),
                                    elevation: 5.0,
                                    child: new Container(
                                      width: MediaQuery.of(context).size.width -
                                          20.0,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.47,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: new Form(
                                          key: formKey,
                                          child: new Container(
                                            padding: EdgeInsets.all(25.0),
                                            child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Login',
                                                  style: heading35Black,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                new Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        controller:
                                                            _controllerEmail,
                                                        validator: validations
                                                            .validateEmail,
                                                        decoration:
                                                            InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3.0),
                                                                ),
                                                                prefixIcon: Icon(
                                                                    Icons.email,
                                                                    color: Colors
                                                                        .blue,
                                                                    size: 20.0),
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            15.0,
                                                                        top:
                                                                            15.0),
                                                                hintText:
                                                                    'Email',
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontFamily:
                                                                        'Quicksand'))),
                                                    SizedBox(height: 20),
                                                    TextFormField(
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller:
                                                            _controllerPassword,
                                                        validator: validations
                                                            .validatePassword,
                                                        obscureText: true,
                                                        decoration:
                                                            InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3.0),
                                                                ),
                                                                prefixIcon: Icon(
                                                                    Icons.lock,
                                                                    color: Colors
                                                                        .blue,
                                                                    size: 20.0),
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            15.0,
                                                                        top:
                                                                            15.0),
                                                                hintText:
                                                                    'Password',
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontFamily:
                                                                        'Quicksand'))),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20.0,
                                                ),
                                                new ButtonTheme(
                                                  height: 40.0,
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  child: RaisedButton.icon(
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    3.0)),
                                                    elevation: 20.0,
                                                    color: primaryColor,
                                                    icon: new Text(''),
                                                    label: new Text('Login',
                                                        style: headingWhite),
                                                    onPressed: () {
                                                      process_login(context);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  )),
                                  new Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 20.0, 0.0, 20.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Text(
                                            "Create new account? ",
                                            style: textGrey,
                                          ),
                                          new InkWell(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed(
                                                    AppRoute.signUpPhone),
                                            child: new Text(
                                              "Sign Up",
                                              style: textStyleActive,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ))),
                    ])
                  ]),
            )),
          );
    // }else{
    //   return BookforPage();
    // }
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
