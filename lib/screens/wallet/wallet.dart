import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rush/components/balance_card.dart';
import 'package:rush/components/loading.dart';
import 'package:rush/config.dart';
import 'package:rush/providers/wallet_state.dart';
import 'package:rush/theme/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  final String screenTitle;

  const WalletScreen({Key key, this.screenTitle}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isBusy = false;
  String balance;
  var publicKey = 'pk_live_8862c01114f4885c76468b9fb557eca745e0423d';
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: publicKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        elevation: 0.0,
      ),
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: BalanceCard()
      ),
    );
  }
}
