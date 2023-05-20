import 'package:hive_flutter/hive_flutter.dart';

part 'borrower.g.dart';

// hive type must be unique.
@HiveType(typeId: 1)
class Borrower extends HiveObject {
  // note: if you want to change name, type of hive field you need increase number of it
  // and should unique (In case your app already deploy).
  @HiveField(0)
  final String name;
  @HiveField(2)
  final String id;

  Borrower(this.name, this.id);
}