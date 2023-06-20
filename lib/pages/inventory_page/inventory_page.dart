import 'package:flutter/material.dart';

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
            ElevatedButton(onPressed: () {}, child: const Text('Tap me')),
          ],
        ),
      ),
    );
  }
}
