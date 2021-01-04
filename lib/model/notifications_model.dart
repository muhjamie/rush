class Notifications {
  final String title;
  final String notification;
  final String status;

  Notifications({this.title, this.notification, this.status});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      title: json['data']['addresses'][0]['label'].toString(),
      notification: json['data']['addresses'][0]['address'].toString(),
      status: json['data']['addresses'][0]['lat'].toString()
    );
  }

  Map toJson() {
    return {'title': title, 'notification': notification, 'status': status};
  }
}