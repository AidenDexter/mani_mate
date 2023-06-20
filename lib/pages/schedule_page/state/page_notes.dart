import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/note_model.dart';
import '../../../providers/notes.dart';
import 'current_date.dart';

part 'page_notes.g.dart';

@Riverpod(keepAlive: true)
Future<List<NoteModel>> pageNotes(PageNotesRef ref) async {
  final notes = await ref.watch(notesProvider.future);
  final currentDate = ref.watch(currentDateProvider);

  return notes
      .where((element) =>
          element.startDate.day == currentDate.day &&
          element.startDate.month == currentDate.month &&
          element.startDate.year == currentDate.year)
      .toList();
}
