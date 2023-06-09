import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'components/bottom_bar.dart';

class TabsPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const TabsPage(this.navigationShell, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomBar(navigationShell),
    );
  }
}
