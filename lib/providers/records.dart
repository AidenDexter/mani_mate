import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../models/record_model.dart';
import 'clients.dart';
import 'notification.dart';

part 'records.g.dart';

@Riverpod(keepAlive: true)
class Records extends _$Records {
  late final Box<RecordModel> box;
  late final Uuid uuid;
  @override
  Future<List<RecordModel>> build() async {
    Hive.registerAdapter(RecordModelAdapter());

    uuid = const Uuid();
    box = await Hive.openBox<RecordModel>('recordsBox');

    return box.values.toList();
  }

  Future<void> addRecord({
    required String clientId,
    required DateTime startDate,
    required DateTime endDate,
    String? text,
    int? price,
    required int timeOfCreate,
  }) async {
    final newNote = RecordModel(
      id: uuid.v1(),
      clientId: clientId,
      startDate: startDate,
      endDate: endDate,
      text: text,
      price: price,
      timeOfCreate: timeOfCreate,
    );
    await box.add(newNote);
    final client = ref.read(clientsProvider).value!.firstWhere((element) => element.id == newNote.clientId);
    ref.read(notificationProvider).value!.scheduleRecordNotification(newNote, client.name);
    state = AsyncValue.data(box.values.toList());
  }

  Future<void> deleteRecordById(String id) async {
    final index = state.value?.indexWhere((element) => element.id == id);
    if (index == null) return;
    await box.deleteAt(index);
    state = AsyncValue.data(box.values.toList());
  }

  Future<void> updateRecord(RecordModel record) async {
    final index = state.value?.indexWhere((element) => element.id == record.id);
    if (index == null) return;
    await box.putAt(index, record);
    state = AsyncValue.data(box.values.toList());
  }

  Future<void> deleteRecordsByClientId(String clientId) async {
    final records = state.value!;
    records.removeWhere((element) => element.clientId == clientId);
    await box.clear();
    await box.addAll(records);
    state = AsyncValue.data(records);
  }
}
