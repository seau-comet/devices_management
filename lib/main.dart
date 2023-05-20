import 'package:devices_management/constants/route_path.dart';
import 'package:devices_management/pages/add_page.dart';
import 'package:devices_management/pages/device_page.dart';
import 'package:devices_management/pages/reserve_page.dart';
import 'package:devices_management/services/local_database_service.dart';
import 'package:devices_management/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  // initialize local database
  await LocalDatabaseService.instance.initialize();
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
        RoutePath.home: (context) => const DevicesPage(),
        RoutePath.reserve: (context) => const ReservePage(),
        RoutePath.add: (context) => AddPage(),
      },
      initialRoute: RoutePath.home,
      debugShowCheckedModeBanner: false,
    );
  }
}
