import 'package:flutter/material.dart';
import 'package:rush/screens/auth/login.dart';
import 'package:rush/screens/history/driver_detail.dart';
import 'package:rush/screens/auth/signup_phone.dart';
import 'package:rush/screens/home/home.dart';
import 'package:rush/screens/pickup/details.dart';
import 'package:rush/screens/pickup/pickup.dart';
import 'package:rush/screens/splash/splash.dart';

class PageViewTransition<T> extends MaterialPageRoute<T> {
  PageViewTransition({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == 'splashScreen') return child;
    if (animation.status == AnimationStatus.reverse)
      return super
          .buildTransitions(context, animation, secondaryAnimation, child);
    return FadeTransition(opacity: animation, child: child);
  }
}

class AppRoute {
  static const String splashScreen = '/splashScreen';
  static const String loginScreen = '/login';
  static const String signUpPhone = '/verify';
  static const String signUpScreen = '/signup';
  static const String forgotPassword = '/forgotPassword';
  static const String introScreen = '/intro';
  static const String phoneVerificationScreen = '/PhoneVerification';
  static const String newsLetter = '/newsLetter';
  static const String bookingScreen = '/booking';
  static const String pickupDetailsScreen = '/pickupDetails';
  static const String pickupScreen = '/pickupScreen';
  static const String pickupDetails = '/pickupDetails';
  static const String dropoffScreen = '/dropoff';
  static const String selectAddressMap = '/selectAddressMap';
  static const String homeScreen = '/home';
  static const String homeScreen2 = '/home2';
  static const String searchScreen = '/search';
  static const String notificationScreen = '/notification';
  static const String profileScreen = '/profile';
  static const String paymentMethodScreen = '/paymentMethod';
  static const String historyScreen = '/history';
  static const String driverDetailScreen = '/driverDetail';
  static const String settingsScreen = '/settings';
  static const String reviewTripScreen = '/reviewTrip';
  static const String cancellationReasonsScreen = '/cancellationReasons';
  static const String termsConditionsScreen = '/termsConditions';
  static const String chatScreen = '/chat';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return PageViewTransition(builder: (_) => SplashScreen());
      case loginScreen:
        return PageViewTransition(builder: (_) => LoginScreen());
      case signUpPhone:
        return PageViewTransition(builder: (_) => SignupPhone());
      case pickupScreen:
        return PageViewTransition(builder: (_) => PickupScreen());
      case homeScreen:
        return PageViewTransition(builder: (_) => HomeScreen());
      case pickupDetailsScreen:
        return PageViewTransition(builder: (_) => PickupDetails());
      case driverDetailScreen:
        return PageViewTransition(builder: (_) => DriverDetailScreen());
      /*case signUpPhone:
        return PageViewTransition(builder: (_) => SignupPhone());
      case introScreen:
        return PageViewTransition(builder: (_) => IntroScreen());
      case phoneVerificationScreen:
        return PageViewTransition(builder: (_) => PhoneVerification());
      case bookingScreen:
        return PageViewTransition(builder: (_) => BookingScreen());
      case pickupScreen:
        return PageViewTransition(builder: (_) => PickupScreen());
      case dropoffScreen:
        return PageViewTransition(builder: (_) => DropoffScreen());
    */ /* case selectAddressMap:
        return PageViewTransition(builder: (_) => SelectAddressMap());*/ /*
      case homeScreen2:
        return PageViewTransition(builder: (_) => HomeScreen2());
      case signUpScreen:
        return PageViewTransition(builder: (_) => SignupScreen());
      case notificationScreen:
        return PageViewTransition(builder: (_) => NotificationScreens());
      case profileScreen:
        return PageViewTransition(builder: (_) => ProfileScreen());
      case paymentMethodScreen:
        return PageViewTransition(builder: (_) => PaymentMethodScreen());
      case historyScreen:
        return PageViewTransition(builder: (_) => HistoryScreen());
      case settingsScreen:
        return PageViewTransition(builder: (_) => SettingsScreen());
      case reviewTripScreen:
        return PageViewTransition(builder: (_) => ReviewTripScreen());
      case cancellationReasonsScreen:
        return PageViewTransition(builder: (_) => CancellationReasonsScreen());
      case termsConditionsScreen:
        return PageViewTransition(builder: (_) => TermsConditionsScreen());
      case driverDetailScreen:
        return PageViewTransition(builder: (_) => DriverDetailScreen());
      case chatScreen:
        return PageViewTransition(builder: (_) => ChatScreen());*/
      default:
        return PageViewTransition(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
