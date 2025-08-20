import 'package:uuid/uuid.dart';

class EventItem {
  final String id;
  String title;
  DateTime expiration;
  String? subtitle;
  DateTime userChosenTime;

  EventItem({
    required this.title,
    DateTime? expiration,
    this.subtitle,
    required this.userChosenTime
  })  : expiration = expiration ?? DateTime.now(),
        id = Uuid().v4();
}
