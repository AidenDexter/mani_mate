import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pages/add_client_page/add_client_page.dart';
import 'pages/clients_page/clients_page.dart';
import 'pages/inventory_page/inventory_page.dart';
import 'pages/schedule_page/schedule_page.dart';
import 'pages/tabs_page/tabs_page.dart';

part 'router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}
