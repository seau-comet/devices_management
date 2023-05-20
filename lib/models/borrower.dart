import 'package:devices_management/constants/hive_number.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'borrower.g.dart';

// hive type must be unique.
@HiveType(typeId: HiveNumber.borrower)
class Borrower extends HiveObject {
  // note: if you want to change name, type of hive field you need increase number of it
  // and should unique (In case your app already deploy).
  @HiveField(0)
  final String name;
  @HiveField(2)
  final String id;

  Borrower(this.name, this.id);
}
