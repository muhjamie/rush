import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rush/components/loading.dart';
import 'package:rush/components/ink_well_custom.dart';
import 'package:rush/components/validations.dart';
import 'package:rush/config.dart';
import 'package:rush/screens/auth/register.dart';
import 'package:rush/theme/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPhone extends StatefulWidget {
  @override
  _SignupPhoneState createState() => _SignupPhoneState();
}

class _SignupPhoneState extends State<SignupPhone> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autovalidate = false;
  Validations validations = new Validations();
  TextEditingController phoneController = TextEditingController();
  // For CircularProgressIndicator.
  bool visible = false ;
  AnimationController _animationController;
  Animation<Color> _colorTween;
  bool loading = false;

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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future rshRegister(context) async {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      setState(() => loading = true );
      String phone = phoneController.text;
      var url = Config.apiurl + 'auth/regphone';
      final response = await http.post(url, body: {
        'phone': phone,
        'usertype': '1',
        'clientId': '1',
      });

      print(response.body);

      var data = json.decode(response.body);
      if(data['success'] == false) {
        setState(() => loading = false);
        showInfoFlushbar(context, data['data']);
      }

      if(data['success'] == true) {
        setState(() => visible = false);
        var userid = data['data']['userid'];
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new SignupScreen(userid: userid)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? LoadingBuilder() : Scaffold(
      key: scaffoldKey,
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
                                  //padding: EdgeInsets.only(top: 100.0),
                                    child: new Material(
                                      borderRadius: BorderRadius.circular(7.0),
                                      elevation: 5.0,
                                      child: new Container(
                                        width: MediaQuery.of(context).size.width - 20.0,
                                        height: MediaQuery.of(context).size.height *0.4,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0)),
                                        child: new Form(
                                            key: formKey,
                                            child: new Container(
                                              padding: EdgeInsets.all(32.0),
                                              child: new Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text('Welcome', style: heading35Black,
                                                  ),
                                                  new Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      TextFormField(
                                                          keyboardType: TextInputType.phone,
                                                          validator: validations.validateMobile,
                                                          controller: phoneController,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(3.0),
                                                              ),
                                                              prefixIcon: Icon(Icons.phone,
                                                                  color: Color(getColorHexFromStr('#1152FD')), size: 20.0),
                                                              contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                                                              hintText: 'Enter phone number',
                                                              hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Quicksand')
                                                          )
                                                      ),
                                                    ],
                                                  ),
                                                  new ButtonTheme(
                                                    height: 40.0,
                                                    minWidth: MediaQuery.of(context).size.width,
                                                    child: RaisedButton.icon(
                                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(3.0)),
                                                      elevation: 30.0,
                                                      color: primaryColor,
                                                      icon: new Text(''),
                                                      label: new Text('Next', style: headingWhite,),
                                                      onPressed:  () => rshRegister(context),

                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            )
                        )
                    ),
                  ]
                  )
                ]
            ),
          )
      ),
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
