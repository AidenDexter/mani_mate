import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/note_model.dart';
import 'pages/add_note_page/add_note_page.dart';
import 'pages/add_record_page/add_record_page.dart';
import 'pages/client_and_services_page/client_and_services_page.dart';
import 'pages/client_page/client_page.dart';
import 'pages/edit_note_page/edit_note_page.dart';
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
