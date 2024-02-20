// ignore_for_file: avoid_print

import 'dart:io';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:flutter_pos/pages/data/login/login_mobile.dart';
import 'package:flutter_pos/pages/data/login/login_mock.dart';
import 'package:flutter_pos/pages/data/login/login_web.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/body/form/edit_single_dish_view.dart';
import 'package:flutter_pos/pages/main_section/drawer/edit_menu/edit_menu_view.dart';
import 'package:flutter_pos/pages/main_section/drawer/login/login_view.dart';
import 'package:flutter_pos/pages/main_section/drawer/reports/report_1/report_view.dart';
import 'package:flutter_pos/pages/main_section/main_page.dart';
import 'package:flutter_pos/utils/app_theme.dart';
import 'package:flutter_pos/widgets/simulate_page_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'pages/main_section/page_view/menu_view/menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.INFO; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print(
      '[${record.level.name}] ${record.loggerName} (${record.time}): '
      '${record.message} ${record.error ?? ''}',
    );
    if (record.stackTrace != null) print(record.stackTrace);
  });

  await dotenv.load(fileName: '.env');

  runApp(
    ProviderScope(
      overrides: [
        loginProvider.overrideWith(
          () {
            // note that kIsWeb check must be first because 'dart:io' (Platform)
            // is not available on the web, running the below lines on web
            // cause 'Unsupported operation' error
            if (kIsWeb) {
              return LoginWeb();
            }
            if (Platform.isAndroid || Platform.isIOS) {
              return LoginMobile();
            }
            return LoginMock();
          },
        ),
      ],
      child: EasyDynamicThemeWidget(
        child: const MyApp(),
      ),
    ),
  );
}

final _logger = Logger('MyApp');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter POS 2',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.bright,
      darkTheme: AppTheme.dark,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      initialRoute: '/',
      home: const Pages(),
      // routes: , we use custom leftSlidingPageBuilder instead of MaterialPageRoute
      onGenerateRoute: (settings) {
        final route = settings.name;
        if (route == null) return null;
        _logger.info('onGenerateRoute $route');

        if (route.contains('/login')) {
          return leftSlidingPageBuilder(
            const LoginView(),
            settings: settings,
            maintainState: false,
          );
        }

        if (route.contains('/report')) {
          return leftSlidingPageBuilder(
            const ReportView(),
            settings: settings,
          );
        }

        if (route.contains('/menu')) {
          // use reg exp to find uri parameters for /menu route
          final regExp = RegExp(r'\/(menu)+\?*.*cardId=([0-9]+)');
          // the uri '/menu?cardId=100' will match above regExp
          final match = regExp.firstMatch(settings.name!);

          if (match != null) {
            final cardIdString = match.group(2); // 2nd parenthesis in reg exp
            if (cardIdString != null) {
              final cardId = int.tryParse(cardIdString);
              if (cardId == null) {
                throw 'Parameter cardId is not an integer';
              }
              _logger.info('Navigating to Menu with cardId $cardId');

              // can not change provider state when widget tree is building,
              // so wrap the action inside post frame callback
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProviderScope.containerOf(context)
                    .read(selectedCardProvider.notifier)
                    .open(cardId);
              });

              return leftSlidingPageBuilder(
                const Menu(),
                settings: settings,
              );
            }
          }
        }

        if (route.contains('/edit-menu')) {
          // use reg exp to find uri parameters for /edit-menu route
          final regExp = RegExp(r'\/(edit-menu)+\?*.*dishId=([0-9]+)');
          // the uri '/edit-menu?dishId=100' will match above regExp
          final match = regExp.firstMatch(settings.name!);

          // no parameters
          if (match == null) {
            _logger.info('Navigating to EditMenuView');
            return leftSlidingPageBuilder(
              const EditMenuView(),
              settings: settings,
            );
          }

          final dishIdString = match.group(2); // 2nd parenthesis in reg exp
          if (dishIdString == null) return null;
          final dishId = int.tryParse(dishIdString);
          if (dishId == null) {
            throw 'Parameter dishId is not an integer';
          }
          _logger.info('Navigating to EditSingleDishView with dishId $dishId');

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ProviderScope.containerOf(context)
                .read(edittingDishIDProvider.notifier)
                .set(dishId);
          });

          return leftSlidingPageBuilder(
            const EditSingleDishView(),
            settings: settings,
          );
        }

        return null;
      },
    );
  }
}
