import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rush/components/loading.dart';
import 'package:rush/components/ink_well_custom.dart';
import 'package:rush/router.dart';
import 'package:rush/config.dart';
import 'package:rush/theme/style.dart';
import 'package:rush/components/validations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  final userid;

  const SignupScreen({Key key, this.userid}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

enum LoginStatus { notSignIn, signIn }

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  var selectedType;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autoValidate = false;
  bool _isLoading = false;
  Validations validations = new Validations();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String _type = '';
  // String type = selectedType;
  AnimationController _animationController;
  Animation<Color> _colorTween;
  bool autovalidate = false;
  PermissionStatus permission;

  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();
  TextEditingController _controllerPhone = new TextEditingController();
  TextEditingController _controllerUserid = new TextEditingController();

  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );
    _colorTween = _animationController
        .drive(ColorTween(begin: Colors.yellow, end: Colors.blue));
    _animationController.repeat();
    super.initState();
  }

  submit() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      signup();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future signup() async {
    setState(() => _isLoading = true);
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String userid = widget.userid;
    String password = _controllerPassword.text;
    String url = Config.apiurl + "auth/updatereg";

    final response = await http.post(url, body: {
      'email': email,
      'name': name,
      'password': password,
      'userid': userid,
      'usertype': '1'
    });

    var result = json.decode(response.body);
    var success = result['success'];

    print(success);
    print(userid);
    print(result);

    if (success == true) {
      String phoneAPI = result['data']['phone'];
      String nameAPI = result['data']['name'];
      String emailAPI = result['data']['email'];
      String usertypeAPI = result['data']['usertype'];
      String id = result['data']['id'];

      savePref(String phone, String name, String email, String usertype,
          String id) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        setState(() {
          preferences.setString("phone", phone);
          preferences.setString("name", name);
          preferences.setString("email", email);
          preferences.setString("usertype", usertype);
          preferences.setString("id", id);
        });
      }

      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(phoneAPI, nameAPI, emailAPI, usertypeAPI, id);
      });

      Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoute.homeScreen, (Route<dynamic> route) => false);

    } else {
      showInfoFlushbar(context, result['data']);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
                      color: Colors.blue[200],
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
                              color: Colors.blue[300].withOpacity(0.5))),
                    ),
                    new Padding(
                        padding: EdgeInsets.fromLTRB(32.0, 100.0, 32.0, 0.0),
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: double.infinity,
                            child: new Column(
                              children: <Widget>[
                                new Container(
                                  //padding: EdgeInsets.only(top: 100.0),
                                    child: new Material(
                                      borderRadius: BorderRadius.circular(7.0),
                                      elevation: 5.0,
                                      child: new Container(
                                        width: MediaQuery.of(context).size.width -
                                            20.0,
                                        height: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(20.0)),
                                        child: new Form(
                                            key: formKey,
                                            child: new Container(
                                              padding: EdgeInsets.all(32.0),
                                              child: new Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Sign up',
                                                    style: heading35Black,
                                                  ),
                                                  new Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      TextFormField(
                                                          controller:
                                                          _controllerName,
                                                          keyboardType:
                                                          TextInputType.text,
                                                          validator: validations
                                                              .validateName,
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
                                                                  Icons
                                                                      .person,
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
                                                              'Name',
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                  'Quicksand'))),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 10.0),
                                                      ),
                                                      TextFormField(
                                                          controller:
                                                          _controllerEmail,
                                                          keyboardType:
                                                          TextInputType
                                                              .emailAddress,
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
                                                                color:
                                                                Colors.blue,
                                                                size: 20.0),
                                                            // color: Color(getColorHexFromStr('#FEDF62')), size: 20.0),
                                                            contentPadding:
                                                            EdgeInsets.only(
                                                                left: 15.0,
                                                                top: 15.0),
                                                            hintText: 'Email',
                                                            hintStyle: TextStyle(
                                                                color:
                                                                Colors.grey,
                                                                fontFamily:
                                                                'Quicksand'),
                                                          )),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top: 10.0),
                                                      ),
                                                      TextFormField(
                                                          controller:
                                                          _controllerPassword,
                                                          keyboardType:
                                                          TextInputType.text,
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
                                                      elevation: 0.0,
                                                      color: primaryColor,
                                                      icon: new Text(''),
                                                      label: new Text(
                                                        'Sign Up',
                                                        style: headingWhite,
                                                      ),
                                                      onPressed: () => submit(),
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
                                          "Already have an account? ",
                                          style: textGrey,
                                        ),
                                        new InkWell(
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(
                                              AppRoute.loginScreen),
                                          child: new Text(
                                            "Sign In",
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
