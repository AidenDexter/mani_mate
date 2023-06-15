import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/add_client_page/add_client_page.dart';
import 'pages/add_note_page/add_note_page.dart';
import 'pages/clients_page/clients_page.dart';
import 'pages/inventory_page/inventory_page.dart';
import 'pages/schedule_page/schedule_page.dart';
import 'pages/tabs_page/tabs_page.dart';

part 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ru')],
        path: 'lang',
        fallbackLocale: const Locale('en'),
        child: const ManiMate(),
      ),
    ),
  );
}

class ManiMate extends StatelessWidget {
  const ManiMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
