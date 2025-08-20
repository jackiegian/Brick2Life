import 'package:uuid/uuid.dart';
import 'account.dart';

class House {
  final String id;
  String title;
  String sharedNotes;

  House({
    required this.title,
    List<Account>? roommates,
    String? sharedNotes,
  })  : id = Uuid().v4().substring(0, 8),
        sharedNotes = sharedNotes ?? "";
}
