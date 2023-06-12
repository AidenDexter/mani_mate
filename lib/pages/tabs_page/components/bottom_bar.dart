import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mani_mate/pages/tabs_page/tabs_page_model.dart';

class BottomBar extends ConsumerWidget {
  const BottomBar(this.navigationShell, {super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(tabsPageModelProvider);
    return BottomNavigationBar(
      currentIndex: position,
      onTap: (value) => _onTap(value, ref),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'clients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory),
          label: 'inventory',
        ),
      ],
    );
  }

  void _onTap(int index, WidgetRef ref) {
    ref.read(tabsPageModelProvider.notifier).setPosition = index;
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    // switch (index) {
    //   case 0:
    //     navigationShell.goBranch('/schedule');
    //   case 1:
    //     navigationShell.goBranch('/clients');
    //   case 2:
    //     navigationShell.goBranch('/inventory');
    // }
  }
}
