import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/add_client_page/add_client_page.dart';
import 'pages/client_and_services_page/client_and_services_page.dart';
import 'pages/client_page/client_page.dart';
import 'pages/inventory_page/inventory_page.dart';
import 'pages/schedule_page/schedule_page.dart';
import 'pages/tabs_page/tabs_page.dart';

part 'router.dart';

Future<void> main() async {
  await Hive.initFlutter();
  runApp(const ProviderScope(child: ManiMate()));
}

class ManiMate extends StatelessWidget {
  const ManiMate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
