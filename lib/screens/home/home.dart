import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:rush/providers/AddressState.dart';
import 'package:rush/providers/PickupState.dart';
import 'package:rush/providers/notifications_state.dart';
import 'package:rush/providers/profile_state.dart';
import 'package:rush/providers/wallet_state.dart';
import 'package:rush/screens/history/booking_history.dart';
import 'package:rush/screens/pickup/pickup.dart';
import 'package:rush/screens/profile/profile.dart';
import 'package:rush/screens/wallet/wallet.dart';
import 'package:rush/theme/style.dart';

class HomeScreen extends StatefulWidget {
  String get screenTitle => null;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();
  final String screenTitle;

  _HomeScreenState({this.screenTitle});

  Future<void> initWallet() {
    final walletState = Provider.of<WalletState>(context, listen: false);
    walletState.getWalletBalance();
  }

  Future<void> initNotifications() {
    final notificationsStates = Provider.of<NotificationsState>(context, listen: false);
    notificationsStates.getNotifications();
  }

  Future<void> initProfile() {
    final profileState = Provider.of<ProfileState>(context, listen: false);
    profileState.getUserProfile();
  }

  Future<void> initHistory() {
    final pickupState = Provider.of<PickupState>(context, listen: false);
    pickupState.requestDrive();
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.location, color: whiteColor,),
        title: ("Home"),
        activeColor: backgroundColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.airport_shuttle, color: whiteColor),
        title: ("History"),
        activeColor: backgroundColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_balance_wallet, color: whiteColor,),
        title: ("Wallet"),
        activeColor: backgroundColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.supervised_user_circle, color: whiteColor,),
        title: ("Profile"),
        activeColor: backgroundColor,
        inactiveColor: CupertinoColors.systemGrey,
      ),
    ];
  }




  List<Widget> _buildScreens() {
    return [
      PickupScreen(screenTitle: "Home"),
      BookingHistoryScreen(),
      WalletScreen(screenTitle: "Wallet"),
      ProfileScreen()
    ];
  }

  @override
  void initState() {
    super.initState();
    initWallet();
    initProfile();
    //initAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: PersistentTabView(
          screens: _buildScreens(),
          items: _navBarItems(),
          confineInSafeArea: true,
          backgroundColor: primaryColor,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears.
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 300),
          ),
          navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
        ),
      ),
    );
  }
}
