import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/client_model.dart';
import '../../../providers/clients.dart';

part 'page_client.g.dart';

@riverpod
class PageClient extends _$PageClient {
  @override
  ClientModel build(String clientId) {
    return ref.watch(clientsProvider).value!.firstWhere((element) => element.id == clientId);
  }
}
