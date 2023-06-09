import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('schedule'),
            ElevatedButton(
                onPressed: () {
                  context.push('/add_client');
                },
                child: Text('Tap me')),
          ],
        ),
      ),
    );
  }
}
