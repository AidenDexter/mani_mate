import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/note_model.dart';
import '../../../providers/notes.dart';
import '../../../providers/time.dart';

class EditNoteButton extends ConsumerWidget {
  final TextEditingController controller;
  final NoteModel oldNote;
  const EditNoteButton(this.controller, this.oldNote, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        ref.read(notesProvider.notifier).updateNote(
              oldNote.copyWith(
                text: controller.text,
                startDate: ref.read(beginDateProvider(oldNote.startDate)),
                endDate: ref.read(endDateProvider(oldNote.endDate)),
              ),
            );
        context.pop();
        controller.clear();
      },
      child: const Icon(Icons.done),
    );
  }
}
