import 'package:flutter/material.dart';

class BluetoothEsp32Theme {
  static final Color accentColor = ekkoPrimaryColorSwatch.shade800;
  static final Color primaryTextColor = ekkoPrimaryColorSwatch.shade900;
  static final Color invertTextColor = Colors.white70;
  static ThemeData themeData = ThemeData(
    //brightness: Brightness.light,
    //cursorColor: primaryTextColor,
    fontFamily: 'OpenSans',
    primaryColor: Colors.black,
    //accentColorBrightness: Brightness.dark,s
    primarySwatch: ekkoPrimaryColorSwatch,
   // accentColor: accentColor,

  );

  static MaterialColor ekkoPrimaryColorSwatch =
      MaterialColor(0xFFFFFFFF, swatch);

  static Map<int, Color> swatch = {
    50:Color.fromRGBO(255, 255, 255, 0.1),
    100:Color.fromRGBO(255, 255, 255, 0.2),
    200:Color.fromRGBO(255, 255, 255, 0.3),
    300:Color.fromRGBO(255, 255, 255, 0.3),
    400:Color.fromRGBO(255, 255, 255, 0.4),
    500:Color.fromRGBO(255, 255, 255, 0.5),
    600:Color.fromRGBO(255, 255, 255, 0.6),
    700:Color.fromRGBO(255, 255, 255, 0.7),
    800:Color.fromRGBO(255, 255, 255, 0.8),
    900:Color.fromRGBO(255, 255, 255, 0.9),
  };
}
