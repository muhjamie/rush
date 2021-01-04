import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rush/providers/place_bloc.dart';
import 'package:rush/screens/directions/directions_view.dart';

class DirectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var placeBloc = Provider.of<PlaceBloc>(context);

    return Scaffold(
      body: DirectionsView(
        placeBloc: placeBloc,
      ),
    );
  }
}
