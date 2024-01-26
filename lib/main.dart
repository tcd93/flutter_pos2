// ignore_for_file: avoid_print

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/db.dart';
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
      home: const Pages(),
      routes: {
        '/report': (context) => const ReportView(),
      },
      // use reg exp to find uri parameters for /menu route
      onGenerateRoute: (settings) {
        if (settings.name != null) {
          final regExp = RegExp(r'\/(menu)+\?*.*cardId=([0-9]+)');
          // the uri '/menu?cardId=100' will match above regExp
          final match = regExp.firstMatch(settings.name!);

          if (match != null) {
            final cardIdString = match.group(2); // 2nd parenthesis in reg exp
            if (cardIdString != null) {
              final cardId = int.tryParse(cardIdString);
              if (cardId == null) return null;

              return MaterialPageRoute(
                builder: (context) {
                  // can not change provider state when widget tree is building,
                  // so wrap the action inside post frame callback
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ProviderScope.containerOf(context)
                        .read(selectedCardProvider.notifier)
                        .open(cardId);
                  });

                  return const Menu();
                },
              );
            }
          }
        }
      },
    );
  }
}
