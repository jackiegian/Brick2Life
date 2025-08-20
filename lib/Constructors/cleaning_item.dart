import 'package:uuid/uuid.dart';

class CleaningItem {
  final String id;
  String title;
  String? subtitle;
  DateTime expiration;
  bool isDone;
  DateTime creationDate;
  DateTime completeDate;
  List<String> participants;

  CleaningItem({
    required this.title,
    this.subtitle,
    DateTime? expiration,
    this.isDone = false,
    DateTime? creationDate,
    DateTime? completeDate,
    List<String>? participants,
  })  : expiration = expiration ?? DateTime.now(),
        creationDate = creationDate ?? DateTime.now(),
        completeDate = completeDate ?? DateTime.now(),
        participants = participants ?? [],
        id = Uuid().v4();
}
