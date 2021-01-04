import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush/config.dart';
import 'package:rush/model/PlaceDetailModel.dart';
import 'package:rush/providers/AddressState.dart';
import 'package:rush/providers/GoogleMapServices.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:rush/providers/place_bloc.dart';
import 'package:rush/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAddressScreen extends StatefulWidget {
  final PlaceBloc placeBloc;

  const CreateAddressScreen({Key key, this.placeBloc}) : super(key: key);
  @override
  _CreateAddressScreenState createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends State<CreateAddressScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController labelController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController realAddressController = TextEditingController();
  bool _isBusy = false;
  bool _isFormBusy = false;
  bool autovalidate = false;
  String address;
  var sessionToken = TimeOfDay.now().toString();
  var googleMapServices;
  PlaceDetail _fromPlaceDetail;
  PlaceDetail _toPlaceDetail;
  double _lat;
  double _lng;
  bool _isAddressSelectLoading = false;


  @override
  void initState() {
    super.initState();
    _isBusy = false;
    address = widget?.placeBloc?.formLocation?.name;
  }


  process_address(context) {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      var isValid = validateCredentials(_scaffoldKey, labelController.text, addressController.text, realAddressController.text);
      if(isValid) _saveAddress(context);
    }
  }

  Future _saveAddress(context) async {
    //setState(() => _isBusy = true);
    // SERVER LOGIN API URL
    setState(() {
      _isBusy = true;
    });
    var url = Config.apiurl + 'users/create_address';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getString('userid');
    var accesstoken = sharedPreferences.getString('accesstoken');
    String labelText = labelController.text;
    String addressText = addressController.text;
    String realAddressText = addressController.text;

    final response = await http.post(url, body: {
      "userid": userid,
      "accesstoken": accesstoken,
      "label": labelText,
      "address": addressText,
      "real_address": realAddressText,
      "lat": _lat.toString(),
      "lng": _lng.toString()
    });
    final res = json.decode(response.body);
    print(res);
    final addressState = Provider.of<AddressState>(context, listen: false);
    addressState?.getAddresses();
    if (res['success'] == true) {
      //Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen()));
      setState(() {
        _isBusy = false;
      });
      Navigator.pop(context);
    } else {
      setState(() => _isBusy = false);
      showInfoFlushbar(context, res['data']);
    }
  }

  bool validateCredentials(GlobalKey<ScaffoldState> scaffoldKey, String label, String address, String realAddress) {
    if (label == null || label.isEmpty) {
      showInfoFlushbar(context, 'Enter address label');
      return false;
    }

    if (address == null || address.isEmpty) {
      showInfoFlushbar(context, 'Enter street address');
      return false;
    }

    if (realAddress == null || realAddress.isEmpty) {
      showInfoFlushbar(context, 'Enter real address');
      return false;
    }

    return true;
  }


    @override
    Widget build(BuildContext context) {
      final pickupState = Provider.of<PickupState>( context);
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios, size: 20, color: primaryColor,),
          ),
          title: Container(
            child: Text('Create address',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: blackColor
              ),
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        body: _isFormBusy ? CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: new AlwaysStoppedAnimation<Color>(whiteColor),
        ) : SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: labelController,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                          labelText: 'Whose address is this?',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TypeAheadField(
                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      hideOnEmpty:true,
                      hideOnLoading: true,
                      transitionBuilder: (context, suggestionsBox, animationController) =>
                          FadeTransition(
                            child: suggestionsBox,
                            opacity: CurvedAnimation(
                                parent: animationController,
                                curve: Curves.fastOutSlowIn
                            ),
                          ),
                      direction: AxisDirection.down,
                      debounceDuration: Duration(milliseconds: 500),
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: addressController,
                        autofocus: false,
                        style: TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                                onPressed: () {
                                  addressController.clear();
                                }),
                            labelText: "Search street or area"
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        googleMapServices = GoogleMapServices(sessionToken: sessionToken);
                        return await googleMapServices.getSuggestions(pattern);
                      },

                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          contentPadding: EdgeInsets.all(10.0),
                          title: Text(
                            suggestion.description,
                            style: TextStyle(fontSize: 11),
                          ),
                        );
                      },

                      onSuggestionSelected: (suggestion) async {
                        setState(() {
                          _isAddressSelectLoading = true;
                        });
                        _toPlaceDetail = await googleMapServices.getPlaceDetail(
                            suggestion.placeId, sessionToken);
                        setState(() {
                          addressController.text = suggestion.description;
                          _lat = _toPlaceDetail.lat;
                          _lng = _toPlaceDetail.lng;
                          _isAddressSelectLoading = false;
                        });
                        print("----" + _lat.toString() + "-----" + _lng.toString());
                        sessionToken = null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: realAddressController,
                      readOnly: false,
                      style: TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                          labelText: 'Real address'
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: _isAddressSelectLoading ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                            ),
                          ) : Text('')
                        ),
                        new ButtonTheme(
                          height: 40.0,
                          minWidth: MediaQuery.of(context).size.width * 0.2,
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)
                            ),
                            elevation: 2.0,
                            color: primaryColor,
                            icon: new Text(''),
                            label: _isBusy ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor: new AlwaysStoppedAnimation<Color>(whiteColor),
                              ),
                            ) : new Text('Save',
                                style: TextStyle(fontSize: 15, color: whiteColor)),
                            onPressed: () {
                              !_isBusy ?  process_address(context) : null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
          ),
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

