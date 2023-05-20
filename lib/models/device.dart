import 'package:devices_management/models/borrower.dart';
import 'package:hive/hive.dart';

part 'device.g.dart';

@HiveType(typeId: 2)
class Device {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final Borrower? borrowedBy;

  Device(this.name, this.borrowedBy);

  Device updateDeviceStatus(Borrower? borrowedBy) => Device(name, borrowedBy);
}
