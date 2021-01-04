class Addresses {
  final String label;
  final String address;
  final String lat;
  final String lng;
  final String placeId;

  Addresses({this.label, this.address, this.lat, this.lng, this.placeId});

  factory Addresses.fromJson(Map<String, dynamic> json) {
    return Addresses(
      label: json['data']['addresses'][0]['label'].toString(),
      address: json['data']['addresses'][0]['address'].toString(),
      lat: json['data']['addresses'][0]['lat'].toString(),
      lng: json['data']['addresses'][0]['lng'].toString(),
      placeId: json['data']['addresses'][0]['placeId'],
    );
  }

  Map toJson() {
    return {'label': label, 'address': address, 'lat': lat, 'lng': lng, 'placeid': placeId};
  }
}