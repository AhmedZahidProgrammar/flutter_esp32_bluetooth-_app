import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_esp32_app/app.dart';

void main() {
  runApp(Application());
}
class Application extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: App(),);
  }

}


