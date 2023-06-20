import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../tabs_page_model.dart';

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
  }
}
