# devices_management

This project was created to show you a case, how to create offline by using hive local database. additional, this project will show you how to setup and implement local notification.

## Getting Started
if you want to create hive from scatch, you should follow contents below:
1. Install denpendencies 
    ```bash
    flutter pub add hive
    flutter pub add flutter_hvie
    flutter pub add hive_generator --dev
    flutter pub add build_runner --dev
    ```

2. create model
    
    a model is just a class or object in dart, for example:
    ``` dart
    class Vehicle {
        final String brand;
        final String color;
        final double maxSpeed;
    }
    ```
3. create type adapter for flutter hive
    just using the model above, but adding some annotation For instance: 
    ``` dart
    @HiveType(typeId: 0)
    class Vehicle {
        @HiveField(0)
        final String brand;
        @HiveField(1)
        final String color;
        @HiveField(2)
        final double maxSpeed;
    }
    ```
    HiveType is a table

    HiveField is a field in a table

4. add path for generate the file
    ``` dart
    part 'your-file-name.g.dart';
    @HiveType(typeId: 0)
    class Vehicle {
        @HiveField(0)
        final String brand;
        @HiveField(1)
        final String color;
        @HiveField(2)
        final double maxSpeed;
    }
    ```

5. generate the type adapter

    run below command:
    ```
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
    
    you will get a new file on the same path of your model you just create.

6. register new type adapter and open box on main.dart
    ``` dart
    // lib/constants/hive_box.dart
    enum HiveBox {
        devices,
        borrowers,
        vehicles, // <- add this line
    }
    ```
    add vehicles
    ``` dart 
    // lib/main.dart
    Future<void> main() async {
    // initialize hive
    // Already called WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    // register adapters
    Hive.registerAdapter(DeviceAdapter());
    Hive.registerAdapter(BorrowerAdapter());
    Hive.registerAdapter(VehicleAdapter()); // <- add this line
    // open boxes
    await Future.wait(
        [
        Hive.openBox<Device>(HiveBox.devices.name),
        Hive.openBox<Borrower>(HiveBox.borrowers.name),
        Hive.openBox<Vehicle>(HiveBox.vehicles.name), // <- add this line
        ],
    );
    // create object FlutterLocalNotificationsPlugin
    final localNotification = FlutterLocalNotificationsPlugin();
    // inject FlutterLocalNotificationsPlugin and set up notification service
    await NotificationService.instance.setup(localNotification);
    runApp(const MyApp());
    }
    ```
    Add Hive.registerAdapter(VehicleAdapter());

    Add Hive.openBox<Vehicle>(HiveBox.vehicles.name),

7. Now you can call the CRUD operations, any path of the app
    ``` dart
        Vehicle vehicle = Vehicle("Audi", "Black", 240);
        // add vehicle
        final box = Hive.box<Vehicle>(HiveBox.vehicle.name);
        await box.add(vehicle);
        // get vehicle
        final getVehicle = await box.getAt(0);
        print("First Vehicle $getVehicle")
        // update vehicle
        Vehicle newVehicle = Vehicle(vehicle.brand, "White", vehicle.maxSpeed);
        await box.putAt(0, newVehicle);


        // delete vehicle
         await box.deleteAt(0);


    ```