import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rush/components/loading.dart';
import 'package:rush/components/ink_well_custom.dart';
import 'package:rush/screens/auth/register.dart';
import 'package:rush/router.dart';
import 'package:rush/config.dart';
import 'package:rush/theme/style.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:http/http.dart' as http;

class PhoneVerification extends StatefulWidget {
  final userid;
  final otp;

  const PhoneVerification({Key key, this.userid, this.otp}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController controller = TextEditingController();
  TextEditingController useridController = TextEditingController();
  bool _isLoading = false;

  String thisText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;

  var userid;

  OTPget() async {
    setState(() => _isLoading = true);
    String useri = useridController.text;
    String code = controller.text;
    String url = Config.apiurl + "auth/verify";
    final response = await http.post(url, body: {'userid': useri, 'otp': code});

    var result = json.decode(response.body);
    print(result);

    var success = result['success'];
    if (success == true) {
      var userid = result['data']['userid'];
      var comment = result['data']['comment'];
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new SignupScreen(userid: userid)));
    } else {
      var comment = result['data'];
      showInfoFlushbar(context, comment);
    }

    print(success);
    print(result);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingBuilder()
        : Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: blackColor,
          ),
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed(AppRoute.loginScreen),
        ),
      ),
      body: SingleChildScrollView(
          child: InkWellCustom(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0.0, 20, 0.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                      child: Text(
                        'Verify Phone Number',
                        style: heading35Black,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 0.0),
                      child:
                      Text('Enter the 4 digits code sent to your phone'),
                    ),
                    Center(
                      child: PinCodeTextField(
                        autofocus: true,
                        controller: controller,
                        hideCharacter: true,
                        highlight: true,
                        highlightColor: secondary,
                        defaultBorderColor: blackColor,
                        hasTextBorderColor: primaryColor,
                        maxLength: pinLength,
                        hasError: hasError,
                        maskCharacter: "*",
                        onTextChanged: (text) {
                          setState(() {
                            hasError = false;
                          });
                        },
                        onDone: (text) {
                          OTPget();
                        },
                        wrapAlignment: WrapAlignment.start,
                        pinBoxDecoration: ProvidedPinBoxDecoration
                            .underlinedPinBoxDecoration,
                        pinTextStyle: heading35Black,
                        pinTextAnimatedSwitcherTransition:
                        ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration:
                        Duration(milliseconds: 300),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Visibility(
                              visible: false,
                              child: new TextField(
                                enabled: false,
                                controller: useridController
                                  ..text = '${widget.userid}',
                                decoration: const InputDecoration(
                                  hintText: "Destination",
                                ),
                                // enabled: !_status,
                                // autofocus: !_status,
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 20),
                    ButtonTheme(
                      height: 40.0,
                      minWidth: MediaQuery.of(context).size.width - 50,
                      child: RaisedButton.icon(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(3.0)),
                        elevation: 0.0,
                        color: primaryColor,
                        icon: new Text(''),
                        label: new Text(
                          'Verify Now',
                          style: headingWhite,
                        ),
                        onPressed: () => OTPget(),
                        // {
                        //   Navigator.of(context).pushReplacementNamed(AppRoute.introScreen);
                        // },
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(AppRoute.signUpPhone),
                              child: new Text(
                                "I didn't get a code",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        )),
                  ]),
            ),
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
