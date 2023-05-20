import 'package:devices_management/constants/hive_number.dart';
import 'package:devices_management/models/borrower.dart';
import 'package:hive/hive.dart';

part 'device.g.dart';

@HiveType(typeId: HiveNumber.device)
class Device {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final Borrower? borrowedBy;

  Device(this.name, this.borrowedBy);

  Device updateDeviceStatus(Borrower? borrowedBy) => Device(name, borrowedBy);
}
