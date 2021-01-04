import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rush/components/validations.dart';
import 'package:rush/config.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:rush/providers/wallet_state.dart';
import 'package:rush/theme/light_color.dart';
import 'package:rush/theme/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({Key key}) : super(key: key);

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  TextEditingController amountController = TextEditingController();
  Validations validations = new Validations();
  bool autovalidate = false;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  var publicKey = 'pk_test_9aaa53746b2ed5f828515a7ed602a48c4df64bc2';
  var secretKey = 'sk_test_5630a255822bb0cf0fd4deaf026515edc77e16df';
  String balance;

  Future<void> getWalletBalance() async {
    var url = Config.apiurl + "users/balance";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString('userid');
    final response = await http.post(url, body: {'userid':userid});
    var res = json.decode(response.body);
    if (res['success'] == true) {
      print(res);
      setState(() {
        balance = res['data']['balance'];
      });
    } else {
      setState(() {
        balance = 0.00.toString();
      });
    }
  }

  Future<void> updateWalletBalance(reference, amount, userid, status, rawjson, createdat) async {
    var url = Config.apiurl + "users/update_balance";
    final response = await http.post(url, body: {
      'userid':userid,
      'amount': amount,
      'reference': reference,
      'status': status,
      'rawjson':rawjson,
      'createdat': createdat
    });
    var res = json.decode(response.body);
    print(res);
    if (res['success'] == true) {
      setState(() {
        balance = res['data']['new_balance'];
      });
    }
    setState(() {
      amountController.text = '';
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var walletState = Provider.of<WalletState>(context, listen: false);
    getWalletBalance();
    return Container(
      color: backgroundColor,
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(1)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .27,
            color: Colors.transparent,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Total Balance',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '\u20A6 ',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              color: LightColor.yellow.withAlpha(200)),
                        ),
                        Text(
                          balance != null ? balance.toString() : '0.00',
                          style: GoogleFonts.muli(
                              textStyle: Theme.of(context).textTheme.display1,
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: primaryColor ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        _modalBottomSheetMenu(context);
                      },
                      child: Container(
                          width: 85,
                          padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              color: primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text("Top up", style: TextStyle(
                                  color: Colors.white
                              )),
                            ],
                          )
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Future<void> clearForm() {
    amountController.clear();
    Navigator.pop(context);
  }
  void _modalBottomSheetMenu(BuildContext context){
    showModalBottomSheet(context: context, builder: (builder){
      return new Container(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0)
            )
        ),
        height: 250.0,
        child: new Container(
          padding: EdgeInsets.all(30),
            child: new Center(
              child: new Form(
                onWillPop: () {
                  return clearForm();
                },
                key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        validator: validations.validateAmount,
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter amount",
                          hintStyle: TextStyle(fontSize: 13)
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      new ButtonTheme(
                        height: 40.0,
                        minWidth:
                        MediaQuery.of(context).size.width - 50,
                        child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)
                          ),
                          elevation: 0.0,
                          color: primaryColor,
                          icon: new Text(''),
                          label: new Text('TOP UP WALLET', style: TextStyle(fontSize: 15, color: whiteColor)),
                          onPressed: () {
                            processTopUp(context);
                          },
                        ),
                      ),
                    ],
                  )
              ),
            )),
      );
    }
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return '7RUSHChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String>createAccessCode(skTest, _getReference) async {
    // skTest -> Secret key
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $skTest'};
    Map data = {"amount": 600, "email": "johnsonoye34@gmail.com", "reference": _getReference};
    String payload = json.encode(data);
    http.Response response = await http.post('https://api.paystack.co/transaction/initialize', headers: headers, body: payload);
    final Map res = json.decode(response.body);
    String accessCode = res['data']['access_code'];
    return accessCode;
  }

  void _verifyOnServer(String reference, amount, String userid) async {
    final walletState = Provider.of<WalletState>(context, listen: false);
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+ secretKey
      };

      http.Response response = await http.get('https://api.paystack.co/transaction/verify/' + reference, headers: headers);
      final Map body = json.decode(response.body);
      print(body);
      updateWalletBalance(reference, amount.toString(), userid, body['data']['status'].toString(), body.toString(), body['data']['created_at']);
      getWalletBalance();
      walletState.showInfoFlushbar(context, 'Wallet Topped Up Successfully');
      Navigator.pop(context);
    } catch (e) {
      walletState.showInfoFlushbar(context, e.toString());
    }
  }

  chargeCard(String email, double amount, String reference, String userid) async {
    Charge charge = Charge()..amount = amount.toInt()..reference = reference..email = email;
    CheckoutResponse response = await PaystackPlugin.checkout(context, method: CheckoutMethod.card, charge: charge);

    if (response.status == true) {
      _verifyOnServer(response.reference, amount, userid);
      print(response);
    }
    else {
      //show error
    }
  }

  @override
  void initState() {
    var walletState = Provider.of<WalletState>(context, listen: false);
    setState(() {
      balance = walletState.balance;
    });
    PaystackPlugin.initialize(publicKey: publicKey);
    super.initState();
  }


  processTopUp(context) async {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      SharedPreferences sp = await SharedPreferences.getInstance();
      var email = sp.getString("email");
      var userid = sp.getString("userid");
      var amount = double.parse(amountController.text) * 100;
      try{
        final result = await InternetAddress.lookup('google.com');
        initTopupAPI(userid, amount, email);
      } catch(e) {
        var pickupState = Provider.of<PickupState>(context, listen: false);
        pickupState.showInfoFlushbar(context, 'Unable to connect to internet. Please, turn on your internet connection');
      }
    }
  }

  initTopupAPI(userid, amount, email) async {
    var ref = _getReference();
    var url = Config.apiurl + 'users/init_topup?userid='+ userid + '&amount=' + amount.toString() + '&reference=' + ref;
    final response = await http.get(url);
    var res = json.decode(response.body);
    if(res['success'] == true) {
      chargeCard(email, double.parse(res['data']['amount']), res['data']['reference'], userid.toString());
    } else {
      print(res['data']);
    }
  }
}