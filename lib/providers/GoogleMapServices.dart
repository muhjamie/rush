import 'dart:convert';
import 'package:rush/config.dart';
import 'package:rush/model/PlaceDetailModel.dart';

import 'package:http/http.dart' as http;
import 'package:rush/providers/PickupState.dart';

class GoogleMapServices extends PickupState {
  final String sessionToken;

  GoogleMapServices({this.sessionToken});

  Future<List> getSuggestions(String query) async {
    final String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = 'establishment';
    String url = '$baseUrl?input=$query&key=${Config.apiKey}&type=$type&language=en&components=country:ng&sessiontoken=$sessionToken';

    print('Autocomplete(sessionToken): $sessionToken');

    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final predictions = responseData['predictions'];

    List<Place> suggestions = [];

    for (int i = 0; i < predictions.length; i++) {
      final place = Place.fromJson(predictions[i]);
      suggestions.add(place);
    }

    return suggestions;
  }

  Future<PlaceDetail> getPlaceDetail(String placeId, String token) async {
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url =
        '$baseUrl?key=${Config.apiKey}&place_id=$placeId&language=en&sessiontoken=$token';

    print('Place Detail(sessionToken): $sessionToken');
    final http.Response response = await http.get(url);
    final responseData = json.decode(response.body);
    final result = responseData['result'];

    final PlaceDetail placeDetail = PlaceDetail.fromJson(result);
    PickupState pickupState = PickupState();
    String latitude = placeDetail.lat.toString();
    String  longitude = placeDetail.lng.toString();
    //pickupState.setDropoffLatLng(latitude, longitude);
    print(placeDetail.toMap());

    return placeDetail;
  }
}
