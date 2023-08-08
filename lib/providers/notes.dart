import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unixtime/unixtime.dart';
import 'package:uuid/uuid.dart';

import '../models/note_model.dart';
import 'notification.dart';

part 'notes.g.dart';

@Riverpod(keepAlive: true)
class Notes extends _$Notes {
  late final Box<NoteModel> box;
  late final Uuid uuid;
  @override
  Future<List<NoteModel>> build() async {
    Hive.registerAdapter(NoteModelAdapter());

    uuid = const Uuid();
    box = await Hive.openBox<NoteModel>('notesBox');

    return box.values.toList();
  }

  Future<void> addNote(
      {required DateTime startDate, required DateTime endDate, String? text, required int timeOfCreate}) async {
    final newNote =
        NoteModel(id: uuid.v1(), startDate: startDate, endDate: endDate, text: text, timeOfCreate: timeOfCreate);
    await box.add(newNote);
    ref.read(notificationProvider).value!.scheduleNoteNotification(newNote);
    state = AsyncValue.data(box.values.toList());
  }

  Future<void> deleteNoteById(String id) async {
    final index = state.value?.indexWhere((element) => element.id == id);
    if (index == null) return;
    ref.read(notificationProvider).value!.deleteNotification(state.value![index].timeOfCreate);
    await box.deleteAt(index);
    state = AsyncValue.data(box.values.toList());
  }

  Future<void> updateNote(NoteModel note) async {
    final index = state.value?.indexWhere((element) => element.id == note.id);
    if (index == null) return;
    await box.putAt(index, note);
    state = AsyncValue.data(box.values.toList());
  }
}
