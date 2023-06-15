import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/notes.dart';
import '../state/time.dart';
import '../state/verify.dart';

class AddNoteButton extends ConsumerWidget {
  final TextEditingController controller;
  const AddNoteButton(this.controller, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(verifyDataProvider)
        ? FloatingActionButton(
            onPressed: () {
              ref.read(notesProvider.notifier).addNote(
                    startDate: ref.read(beginDateProvider)!,
                    endDate: ref.read(endDateProvider)!,
                    text: controller.text,
                  );
              context.pop();
              controller.clear();
            },
            child: const Icon(Icons.add),
          )
        : const SizedBox.shrink();
  }
}
