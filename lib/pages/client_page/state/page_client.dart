import 'package:mani_mate/models/client_model.dart';
import 'package:mani_mate/providers/clients.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'page_client.g.dart';

@riverpod
class PageClient extends _$PageClient {
  @override
  ClientModel build(String clientId) {
    return ref.watch(clientsProvider).value!.firstWhere((element) => element.id == clientId);
  }
}
