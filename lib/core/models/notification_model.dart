import 'package:flutter/widgets.dart';

class NotificationModel {
  final String title;
  final String timeStamp;
  final Widget avatar;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.timeStamp,
    required this.avatar,
    required this.isRead,
  });
}
