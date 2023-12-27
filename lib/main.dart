import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/main_section/page.dart';
import 'package:flutter_pos/pages/report_section/report.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'pages/menu_section/menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print(
      '${record.level.name} (${record.time}): ${record.message} ${record.error}',
    );
    if (record.stackTrace != null) print(record.stackTrace);
    print('\n');
  });

  runApp(
    ProviderScope(
      child: EasyDynamicThemeWidget(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Reborn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.bright,
      darkTheme: AppTheme.dark,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => Pages(),
        '/menu': (context) => Menu(),
        '/report': (context) => Report(),
      },
    );
  }
}
