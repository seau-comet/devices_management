import 'package:devices_management/constants/hive_box.dart';
import 'package:devices_management/models/borrower.dart';
import 'package:devices_management/models/device.dart';
import 'package:devices_management/pages/add_page.dart';
import 'package:devices_management/pages/device_page.dart';
import 'package:devices_management/pages/reserve_page.dart';
import 'package:devices_management/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  // initialize hive
  // Already called WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // register adapters
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(BorrowerAdapter());
  // open boxes
  await Future.wait(
    [
      Hive.openBox<Device>(HiveBox.devices.name),
      Hive.openBox<Borrower>(HiveBox.borrowers.name),
    ],
  );
  // create object FlutterLocalNotificationsPlugin
  final localNotification = FlutterLocalNotificationsPlugin();
  // inject FlutterLocalNotificationsPlugin and set up notification service
  await NotificationService.instance.setup(localNotification);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/home": (context) => const DevicesPage(),
        "/reserve": (context) => const ReservePage(),
        "/add": (context) => AddPage(),
      },
      initialRoute: "/home",
    );
  }
}
