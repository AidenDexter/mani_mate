import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../models/note_model.dart';
import '../../../models/record_model.dart';
import '../../../providers/clients.dart';
import '../../../providers/notes.dart';
import '../../../providers/records.dart';

class DeleteConfirmDialog extends ConsumerWidget {
  const DeleteConfirmDialog({super.key, required this.note});

  final NoteModel note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Вы действительно хотите удалить эту запись?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            (note is RecordModel)
                ? Builder(
                    builder: (context) {
                      final record = note as RecordModel;
                      final client = ref.watch(clientsProvider).value?.firstWhere((e) => e.id == record.clientId);
                      return Text('Клиент: ${client?.name}');
                    },
                  )
                : Text('Текст: ${note.text ?? ''}'),
            Text(
                'Время: ${'${DateFormat('HH:mm').format(note.startDate)} - '}${DateFormat('HH:mm').format(note.endDate)}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: context.pop, child: const Text('Отмена')),
                ElevatedButton(
                    onPressed: () {
                      note is RecordModel
                          ? ref.read(recordsProvider.notifier).deleteRecordById(note.id)
                          : ref.read(notesProvider.notifier).deleteNoteById(note.id);
                      context.pop();
                    },
                    child: const Text('Удалить')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
