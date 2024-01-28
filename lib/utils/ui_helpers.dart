import 'dart:ui';

import 'package:flutter/material.dart';

/// Get a prefered width for an item in a horizontal list
double calculateExtent(double width) {
  return switch (width) {
    < 600 /*phone*/ => width / 3,
    >= 600 && < 905 /*tablet*/ => width / 6,
    >= 905 && < 1240 => width / 8,
    >= 1240 && < 1440 => width / 10,
    _ => width / 12,
  };
}

/// Get a prefered margins between items in a horizontal list
double calculateMargin(double width) {
  return switch (width) {
    < 600 => 16,
    >= 600 && < 905 => 32,
    >= 905 && < 1240 => lerpDouble(32, 200, (width - 905) / (1240 - 905))!,
    >= 1240 && < 1440 => 200,
    _ => 232,
  };
}

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
