import 'package:flutter/material.dart';

bool isIOS(BuildContext context) {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return true;
  } else {
    return false;
  }
} // check if android or ios

bool isThemeCurrentlyDark(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.dark) {
    return true;
  } else {
    return false;
  }
} //returns current theme status

// const darkPallete = const {
//   0: Color.fromARGB(255, 8, 25, 34),
//   1: Color.fromARGB(255, 24, 61, 61),
//   2: Color.fromARGB(255, 92, 131, 116),
// };

// const lightPallete = const {
//   0: Color.fromARGB(255, 210, 224, 251),
//   1: Color.fromARGB(255, 249, 243, 204),
//   2: Color.fromARGB(255, 215, 229, 202),
// };
