import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/notes.dart';
import '../../../providers/time.dart';
import '../state/verify.dart';

class AddNoteButton extends ConsumerWidget {
  final TextEditingController controller;
  final DateTime? beginDateTime;
  const AddNoteButton(this.controller, this.beginDateTime, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(verifyDataProvider(beginDateTime: beginDateTime))
        ? FloatingActionButton(
            onPressed: () {
              ref.read(notesProvider.notifier).addNote(
                    startDate: ref.read(beginDateProvider(beginDateTime))!,
                    endDate: ref.read(endDateProvider(beginDateTime?.add(const Duration(minutes: 30))))!,
                    text: controller.text,
                  );
              context.pop();
              controller.clear();
            },
            child: const Icon(Icons.done),
          )
        : const SizedBox.shrink();
  }
}
