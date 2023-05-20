
import 'package:devices_management/constants/hive_box.dart';
import 'package:devices_management/models/device.dart';
import 'package:devices_management/models/borrower.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddPage extends StatelessWidget {
  AddPage({super.key});
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDevice = ModalRoute.of(context)!.settings.arguments as bool;
    return Scaffold(
      appBar: AppBar(
        title: Text(isDevice ? "Add Device" : "Add User"),
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
                label: Text(isDevice ? "Device name" : "Username"),
              ),
            ),
            if (!isDevice)
              Expanded(
                child: ValueListenableBuilder<Box<Borrower>>(
                  valueListenable: Hive.box<Borrower>(HiveBox.borrowers.name).listenable(),
                  builder: (context, box, widget) {
                    return Center(
                      child: ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          Borrower borrower = box.values.toList()[index];
                          return ListTile(
                            title: Text(borrower.name),
                            onTap: () {},
                            onLongPress: () async {
                              await box.deleteAt(index);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            if (isDevice)
              Expanded(
                child: ValueListenableBuilder<Box<Device>>(
                  valueListenable: Hive.box<Device>(HiveBox.devices.name).listenable(),
                  builder: (context, box, widget) {
                    return Center(
                      child: ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          Device device = box.values.toList()[index];
                          return ListTile(
                            title: Text(device.name),
                            onTap: () {},
                            onLongPress: () async {
                              await box.deleteAt(index);
                            },
                          );
                        },
                      ),
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
                  final box = Hive.box<Device>(HiveBox.devices.name);
                  await box.add(Device(nameController.text, null));
                } else {
                  // add borrow
                  final box = Hive.box<Borrower>(HiveBox.borrowers.name);
                  await box.add(Borrower(nameController.text,
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