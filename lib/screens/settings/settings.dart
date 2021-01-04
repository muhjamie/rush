import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rush/screens/settings/contact.dart';
import 'package:rush/screens/settings/content.dart';
import 'package:rush/screens/splash/splash.dart';
import 'package:rush/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String usertc;
  String about;
  @override
  void initState() {
    rootBundle.loadString("assets/files/user-tc.txt").then((file) =>
        setState(() => usertc = file)
    );

    rootBundle.loadString("assets/files/about.txt").then((file) =>
        setState(() => about = file)
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Settings'),

      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Card(
            color: backgroundColor,
            elevation: .2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ContentsScreen(
                        title: "About 7Rush",
                        content: about,
                      )
                      ));
                    },
                    child: Text('About 7Rush', style: TextStyle(fontSize: 14, )),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () { Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ContactScreen(
                      title: "Contact Us",
                    )
                    ));
                    },
                    child: Text("Contact Us", style: TextStyle(fontSize: 14)),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      _logout(context);
                    },
                    child: Text('Logout', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: redColor)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences?.clear();
    Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new SplashScreen()));
  }

  void _about(BuildContext context){
    showModalBottomSheet(context: context, builder: (builder){
      return new Container(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0)
            )
        ),
        height: 500.0,
        child: new Container(
            padding: EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: new Center(
                child: Text('About 7Rush', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )),
      );
    }
    );
  }

  void _userTC(BuildContext context){
    showModalBottomSheet(context: context, builder: (builder){
      return new Container(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0)
            )
        ),
        height: 500.0,
        child: new Container(
          padding: EdgeInsets.all(30),
          child:Column(
            children: <Widget>[
              Text("Users' Terms and Conditions", style: TextStyle(fontWeight: FontWeight.bold)),
              SingleChildScrollView(
                child: new Center(
                    child: Text(usertc)
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}