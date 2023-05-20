import 'package:devices_management/constants/hive_box.dart';
import 'package:devices_management/constants/route_path.dart';
import 'package:devices_management/extensions/int.dart';
import 'package:devices_management/models/device.dart';
import 'package:devices_management/pages/reserve_page.dart';
import 'package:devices_management/widgets/display_box_widget.dart';
import 'package:flutter/material.dart';

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
      body: DisplayBoxWidget<Device>(
        hiveBox: HiveBox.devices,
        child: (context, index, device) {
          return ListTile(
            title: Text(device.name),
            subtitle: Text(device.borrowedBy != null
                ? device.borrowedBy!.name
                : "available"),
            onTap: () {
              Navigator.of(context).pushNamed(
                RoutePath.reserve,
                arguments: ReserveArg(index, device),
              );
            },
          );
        },
      ),
      floatingActionButton: PopupMenuButton<int>(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 0,
            child: Text(
              "Add borrow",
            ),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text(
              "Add Device",
            ),
          ),
        ],
        child: const FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
        onSelected: (value) async {
          // zero is adding user and one is adding device
          Navigator.of(context)
              .pushNamed(RoutePath.add, arguments: value.toBool());
        },
      ),
    );
  }
}
