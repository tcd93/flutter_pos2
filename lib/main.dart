// ignore_for_file: avoid_print

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/main_section/drawer/reports/report_view.dart';
import 'package:flutter_pos/pages/main_section/main_page.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'pages/main_section/page_view/menu_view/menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print(
      '[${record.level.name}] ${record.loggerName} (${record.time}): '
      '${record.message} ${record.error ?? ''}',
    );
    if (record.stackTrace != null) print(record.stackTrace);
  });

  runApp(
    ProviderScope(
      child: EasyDynamicThemeWidget(
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/': (context) => const Pages(),
        '/menu': (context) => const Menu(),
        '/report': (context) => const ReportView(),
      },
    );
  }
}
