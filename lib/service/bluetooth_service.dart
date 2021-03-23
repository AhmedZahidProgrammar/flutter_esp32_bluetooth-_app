import 'package:flutter_blue/flutter_blue.dart';

class BluetoothService{
  FlutterBlue flutterBlue;

  BluetoothService(){
    flutterBlue = FlutterBlue.instance;
  }
  List<String> scanBlueToothDevices(){
    List<String> availableBluetoothDevices=[];
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
        availableBluetoothDevices.add(r.device.name);
      }
    });
    flutterBlue.stopScan();
    return availableBluetoothDevices;
}
}