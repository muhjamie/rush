

import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationEvents {
  PickupScreenClickedEvent,
  WalletScreenClickedEvent,
  MyAccountClickedEvent,
  HistoryClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc({NavigationStates initialState}) : super(initialState);

  @override
  //NavigationStates get initialState => PickupScreen();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.PickupScreenClickedEvent:
        //yield PickupScreen();
        break;
    }
  }
}