import 'package:hive_flutter/hive_flutter.dart';
import 'package:mani_mate/models/note_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> addNote({required DateTime startDate, required DateTime endDate, String? text}) async {
    await box.add(NoteModel(id: uuid.v1(), startDate: startDate, endDate: endDate, text: text));
    state = AsyncValue.data(box.values.toList());
  }

  Future<void> deleteNoteById(String id) async {
    final index = state.value?.indexWhere((element) => element.id == id);
    if (index == null) return;
    await box.deleteAt(index);
    state = AsyncValue.data(box.values.toList());
  }

    Future<void> updateNote(NoteModel client) async {
    final index = state.value?.indexWhere((element) => element.id == client.id);
    if (index == null) return;
    await box.putAt(index, client);
    state = AsyncValue.data(box.values.toList());
  }
}
