import 'package:devices_management/constants/hive_box.dart';
import 'package:devices_management/models/device.dart';
import 'package:devices_management/pages/reserve_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Devices"),
      ),
      body: ValueListenableBuilder<Box<Device>>(
        valueListenable: Hive.box<Device>(HiveBox.devices.name).listenable(),
        builder: (context, box, widget) {
          return Center(
            child: ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Device device = box.values.toList()[index];
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.borrowedBy == null
                      ? "available"
                      : device.borrowedBy?.name ?? ""),
                  onLongPress: () async {
                    await box.deleteAt(index);
                  },
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      "/reserve",
                      arguments: ReserveArg(index, device),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: PopupMenuButton<int>(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 0,
            child: Text(
              "Add User",
            ),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text(
              "Add Device",
            ),
          ),
        ],
        // icon: const Icon(Icons.library_add),
        child: const FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
        onSelected: (value) async {
          // zero is adding user and one is adding device
          Navigator.of(context)
              .pushNamed("/add", arguments: value == 0 ? false : true);
        },
      ),
    );
  }
}
