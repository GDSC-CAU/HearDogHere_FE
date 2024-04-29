import 'package:flutter/material.dart';

class NotificationList with ChangeNotifier {
  List<List<String>> notificationList = [
    ["2024-2-5 5:10", "Laika has escaped"],
    ["2024-2-5 4:03", "Laika is barking"],
    ["2024-2-5 3:30", "Laika is barking"],
    ["2024-2-5 3:03", "Laika is barking"],
    ["2024-2-4 8:03", "Seems like Laika broke something"],
    ["2024-2-4 7:21", "Laika is barking"],
  ];

  AddNotification(List<String> noti) {
    notificationList.add(noti);
    notifyListeners();
  }
}
