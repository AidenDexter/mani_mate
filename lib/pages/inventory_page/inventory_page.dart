import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('inventory'),
            ElevatedButton(
                onPressed: () {
                  context.push('/add_client');
                },
                child: const Text('Tap me')),
          ],
        ),
      ),
    );
  }
}
