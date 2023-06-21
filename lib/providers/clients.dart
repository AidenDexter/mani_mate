import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../models/client_model.dart';
import 'records.dart';

part 'clients.g.dart';

@Riverpod(keepAlive: true)
class Clients extends _$Clients {
  late final Box<ClientModel> box;
  late final Uuid uuid;
  @override
  Future<List<ClientModel>> build() async {
    Hive.registerAdapter(ClientModelAdapter());
    uuid = const Uuid();
    box = await Hive.openBox<ClientModel>('clientsBox');

    return box.values.toList();
  }

  Future<void> add(String name, String phone, String note) async {
    await box.add(ClientModel(uuid.v1(), name, phone, note));
    state = AsyncValue.data(box.values.toList());
  }

  Future<void> clear() async {
    await box.clear();
    state = AsyncValue.data(box.values.toList());
  }

  Future<void> deleteById(String id) async {
    final index = state.value?.indexWhere((element) => element.id == id);
    if (index == null) return;
    await box.deleteAt(index);
    state = AsyncValue.data(box.values.toList());
    ref.read(recordsProvider.notifier).deleteRecordsByClientId(id);
  }

  Future<void> updateClient(ClientModel client) async {
    final index = state.value?.indexWhere((element) => element.id == client.id);
    if (index == null) return;
    await box.putAt(index, client);
    state = AsyncValue.data(box.values.toList());
  }
}
