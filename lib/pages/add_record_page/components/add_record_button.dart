import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unixtime/unixtime.dart';

import '../../../providers/records.dart';
import '../../../providers/time.dart';
import '../state/current_client.dart';
import '../state/verify.dart';

class AddRecordButton extends ConsumerWidget {
  final TextEditingController noteController;
  final TextEditingController priceController;

  final DateTime? beginDateTime;
  const AddRecordButton(this.noteController, this.priceController, this.beginDateTime, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(verifyDataProvider(beginDateTime: beginDateTime))
        ? FloatingActionButton(
            onPressed: () {
              ref.read(recordsProvider.notifier).addRecord(
                    clientId: ref.read(currentClientProvider())!.id,
                    startDate: ref.read(beginDateProvider(beginDateTime))!,
                    endDate: ref.read(endDateProvider(beginDateTime?.add(const Duration(minutes: 30))))!,
                    text: noteController.text,
                    price: priceController.text.trim().isEmpty ? null : int.parse(priceController.text),
                    timeOfCreate: DateTime.now().unixtime,
                  );
              context.pop();
              noteController.clear();
            },
            child: const Icon(Icons.done),
          )
        : const SizedBox.shrink();
  }
}
