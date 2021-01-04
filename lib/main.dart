import 'package:flutter/services.dart';
import 'package:rush/providers/AddressState.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush/providers/AppState.dart';
import 'package:rush/providers/PlaceState.dart';
import 'package:rush/providers/notifications_state.dart';
import 'package:rush/providers/place_bloc.dart';
import 'package:rush/providers/profile_state.dart';
import 'package:rush/providers/wallet_state.dart';
import 'package:rush/router.dart';
import 'package:rush/screens/splash/splash.dart';

import 'theme/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: primaryColor
    ));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>(create: (context) => AppState()),
          ChangeNotifierProvider<PickupState>(create: (context) => PickupState()),
          ChangeNotifierProvider<PlaceState>(create: (context) => PlaceState()),
          ChangeNotifierProvider<PlaceBloc>(create: (context) => PlaceBloc()),
          ChangeNotifierProvider<WalletState>(create: (context) => WalletState()),
          ChangeNotifierProvider<ProfileState>(create: (context) => ProfileState()),
          ChangeNotifierProvider<AddressState>(create: (context) => AddressState()),
          ChangeNotifierProvider<NotificationsState>(create: (context) => NotificationsState()),
        ],
        child: MaterialApp(
          title: '7Rush',
          theme: appTheme,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRoute.generateRoute,
          home: SplashScreen(),
        ));
  }
}
