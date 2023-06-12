import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mani_mate/pages/schedule_page/state/page_notes.dart';
import 'package:mani_mate/providers/notes.dart';

class NotesList extends ConsumerWidget {
  const NotesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(pageNotesProvider);

    return Expanded(
      child: notes.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final note = data[index];
              return Column(
                children: [
                  Text(note.id),
                  Text(note.startDate.toString()),
                  Text(note.endDate.toString()),
                  Text(note.text ?? 'trest'),
                  ElevatedButton(
                      onPressed: () => ref.read(notesProvider.notifier).deleteNoteById(note.id), child: const Text('delete')),
                  ElevatedButton(
                      onPressed: () => ref.read(notesProvider.notifier).updateNote(note.copyWith(text: 'updated')),
                      child: const Text('update')),
                ],
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
