import 'package:uuid/uuid.dart';
import 'account.dart';

class ShoppingItem {
  final String id;
  String title;
  String? subtitle;
  Account? buyer;

  bool isComplete;

  ShoppingItem({
    required this.title,
    this.subtitle,
    this.buyer,
    this.isComplete = false,
  }) : id = Uuid().v4();
}