import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/client_model.dart';

part 'current_client.g.dart';

@riverpod
class CurrentClient extends _$CurrentClient {
  @override
  ClientModel? build() => null;

  set client(ClientModel newClient) => state = newClient;
}
