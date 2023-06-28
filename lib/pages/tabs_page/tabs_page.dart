import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/notification.dart';
import 'components/bottom_bar.dart';

class TabsPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const TabsPage(this.navigationShell, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notification = ref.watch(notificationProvider);
        return notification.when(
          data: (data) {
            return Scaffold(
              body: navigationShell,
              bottomNavigationBar: BottomBar(navigationShell),
            );
          },
          error: (error, s) => SizedBox.shrink(),
          loading: () => CircularProgressIndicator(),
        );
      },
    );
  }
}
