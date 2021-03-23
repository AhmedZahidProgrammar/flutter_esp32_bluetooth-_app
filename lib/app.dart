import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_esp32_app/bluetooth_esp32_theme.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'ChatPage.dart';
import 'DiscoveryPage.dart';
import 'SelectBondedDevicePage.dart';
class App extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _App();
  }

}
class _App extends State<App>{
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _address = "...";
  String _name = "...";
  int _discoverableTimeoutSecondsLeft = 0;
  bool _autoAcceptPairingRequests = false;
  Timer _discoverableTimeoutTimer;
  //BackgroundCollectingTask _collectingTask;


  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }
  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:BluetoothEsp32Theme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: Text("ESP32 Bluetooth App"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(8.0),
                child:Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Enable Bluetooth'),
                      value: _bluetoothState.isEnabled,
                      onChanged: (bool value) {
                        // Do the request and update with the true value then
                        future() async {
                          // async lambda seems to not working
                          if (value)
                            await FlutterBluetoothSerial.instance.requestEnable();
                          else
                            await FlutterBluetoothSerial.instance.requestDisable();
                        }
                        future().then((_) {
                          setState(() {

                          });
                        });
                      },
                    ),
                    ListTile(
                      title: RaisedButton(
                        child: const Text('Connect to paired device to chat'),
                        onPressed: () async {
                          final BluetoothDevice selectedDevice =
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SelectBondedDevicePage(checkAvailability: false);
                              },
                            ),
                          );

                          if (selectedDevice != null) {
                            print('Connect -> selected ' + selectedDevice.address);
                            _startChat(context, selectedDevice);
                          } else {
                            print('Connect -> no device selected');
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: RaisedButton(
                          child: const Text('Explore discovered devices'),
                          onPressed: () async {
                            final BluetoothDevice selectedDevice =
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return DiscoveryPage();
                                },
                              ),
                            );

                            if (selectedDevice != null) {
                              print('Discovery -> selected ' + selectedDevice.address);
                            } else {
                              print('Discovery -> no device selected');
                            }
                          }),
                    ),
                    ListTile(
                      title: const Text('Bluetooth status'),
                      subtitle: Text(_bluetoothState.toString()),
                      trailing: ElevatedButton(
                        child: const Text('Settings'),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)
                                )
                            )
                        ),
                        onPressed: () {
                          FlutterBluetoothSerial.instance.openSettings();
                        },
                      ),
                    ),
                  ],
                )
              ),

            ],
          ),
        )
      ),
    );
  }
  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }
}