import 'package:devices_management/constants/hive_box.dart';
import 'package:devices_management/models/device.dart';
import 'package:devices_management/models/borrower.dart';
import 'package:devices_management/services/local_database_service.dart';
import 'package:devices_management/services/notification_service.dart';
import 'package:devices_management/widgets/display_box_widget.dart';
import 'package:flutter/material.dart';

class ReserveArg {
  final int key;
  final Device device;

  ReserveArg(this.key, this.device);
}

class ReservePage extends StatelessWidget {
  const ReservePage({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as ReserveArg;
    return Scaffold(
      appBar: AppBar(
        title: Text(arg.device.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select borrower",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
                child: DisplayBoxWidget<Borrower>(
              hiveBox: HiveBox.borrowers,
              child: (context, index, borrower) {
                return ListTile(
                  title: Text(borrower.name),
                  selected: borrower.id == arg.device.borrowedBy?.id,
                  onTap: () async {
                    Borrower? selectBorrower = borrower;
                    // if user click on reserve borrower, it will cancel that borrow
                    if (borrower.id == arg.device.borrowedBy?.id) {
                      selectBorrower = null;
                    }

                    // update data to local notification
                    await LocalDatabaseService.instance.putAt<Device>(
                        HiveBox.devices,
                        arg.key,
                        arg.device.updateDeviceStatus(selectBorrower));
                    
                    // send local notification only reserve, no need to send when cancel
                    if (selectBorrower != null) {
                      await NotificationService.instance
                          .showScheduledLocalNotification(
                              title: "Warning!",
                              body:
                                  "${selectBorrower.name} need to sent the device ${arg.device.name} back",
                              payload: "${selectBorrower.name} time out!",
                              endTime: 2);
                    }
                    // Don't use 'BuildContext's across async gaps.
                    // Try rewriting the code to not reference the 'BuildContext'.
                    // flutter update
                    if (context.mounted) Navigator.pop(context);
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
