import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mani_mate/providers/clients.dart';

class SchedulePage extends ConsumerWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientsProvider);
    return clients.when(
        data: (data) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.push('/add_client');
                  },
                  child: const Text('Tap me'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(clientsProvider.notifier).add();
                  },
                  child: const Text('add'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(clientsProvider.notifier).clear();
                  },
                  child: const Text('clear'),
                ),
              ],
            ),
          );
        },
        error: (Object error, StackTrace stackTrace) => Center(
              child: Text(error.toString()),
            ),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
