import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../schedule_page/state/current_date.dart';

class PageAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PageAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = ref.watch(currentDateProvider);

    return AppBar(
      leading: IconButton(
        onPressed: context.pop,
        splashRadius: 25,
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.black,
        ),
      ),
      title: Text(
        DateFormat('dd MMMM yyyy').format(currentDate),
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
