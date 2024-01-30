import 'package:flutter/material.dart';
import 'package:flutter_pos/utils/color_schemes.g.dart';

class AppTheme {
  static const carouselDuration = 300;
  static const double beginHeightFactor = 0.4;
  static const double beginWidthFactor = 0.7;
  static const int cardExpandDuration = 550;
  static const double cardHeightMax = 140;
  static const double endHeightFactor = 1.0;
  static const double endWidthFactor = 0.98;

  static final bright = ThemeData(
    fontFamily: 'Quicksand',
    colorScheme: lightColorScheme,
    useMaterial3: true,
    splashFactory: InkSplash.splashFactory,
    cardTheme: CardTheme(
      elevation: 0.0,
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      margin: const EdgeInsets.all(0),
      shape: BeveledRectangleBorder(
        side: BorderSide(
          color: lightColorScheme.onBackground,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      shape: Border.all(color: Colors.transparent, width: 0),
    ),
    drawerTheme: const DrawerThemeData(
      shape: BeveledRectangleBorder(),
      endShape: BeveledRectangleBorder(),
    ),
    dialogTheme: const DialogTheme(
      shape: BeveledRectangleBorder(),
    ),
  );
  static final dark = ThemeData(
    fontFamily: 'Quicksand',
    colorScheme: darkColorScheme,
    useMaterial3: true,
    splashFactory: InkSplash.splashFactory,
    cardTheme: CardTheme(
      elevation: 0.0,
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      margin: const EdgeInsets.all(0),
      shape: BeveledRectangleBorder(
        side: BorderSide(
          color: darkColorScheme.onBackground,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      shape: Border.all(color: Colors.transparent, width: 0),
    ),
    drawerTheme: const DrawerThemeData(
      shape: BeveledRectangleBorder(),
      endShape: BeveledRectangleBorder(),
    ),
    dialogTheme: const DialogTheme(
      shape: BeveledRectangleBorder(),
    ),
    dividerTheme: DividerThemeData(
      color: darkColorScheme.outline,
    ),
  );
}
