import 'package:devices_management/constants/hive_box.dart';
import 'package:devices_management/models/device.dart';
import 'package:devices_management/models/borrower.dart';
import 'package:devices_management/services/local_database_service.dart';
import 'package:devices_management/widgets/display_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPage extends StatelessWidget {
  AddPage({super.key});
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDevice = ModalRoute.of(context)!.settings.arguments as bool;
    return Scaffold(
      appBar: AppBar(
        title: Text(isDevice ? "Add Device" : "Add Borrower"),
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                label: Text(isDevice ? "Device name" : "Borrower name"),
              ),
            ),
            // display list of devices when navigate as add device
            if (isDevice)
              Expanded(
                child: DisplayBoxWidget<Device>(
                  hiveBox: HiveBox.devices,
                  child: (context, index, device) {
                    return ListTile(
                      title: Text(device.name),
                      onTap: null,
                      onLongPress: () async {
                        await LocalDatabaseService.instance
                            .deleteAt<Device>(HiveBox.devices, index);
                      },
                    );
                  },
                ),
              ),
            // display list of devices when navigate as add borrow
            if (!isDevice)
              Expanded(
                child: DisplayBoxWidget<Borrower>(
                  hiveBox: HiveBox.borrowers,
                  child: (context, index, borrower) {
                    return ListTile(
                      title: Text(borrower.name),
                      onTap: null,
                      onLongPress: () async {
                        await LocalDatabaseService.instance
                            .deleteAt<Borrower>(HiveBox.borrowers, index);
                      },
                    );
                  },
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 48),
              ),
              onPressed: () async {
                final title = isDevice ? "device name" : "username";
                // validate if text field is empty
                if (nameController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Please fill the $title");
                  return;
                }
                if (isDevice) {
                  // add device
                  await LocalDatabaseService.instance.add<Device>(
                      HiveBox.devices, Device(nameController.text, null));
                } else {
                  // add borrow
                  await LocalDatabaseService.instance.add<Borrower>(
                      HiveBox.borrowers,
                      Borrower(nameController.text,
                          DateTime.now().millisecond.toString()));
                }
          
                nameController.clear();
                Fluttertoast.showToast(msg: "added!");
              },
              child: const Text("Add"),
            )
          ],
        ),
      ),
    );
  }
}
