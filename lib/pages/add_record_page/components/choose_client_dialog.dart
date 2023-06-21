import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/client_model.dart';
import '../../../providers/clients.dart';
import '../state/current_client.dart';

class ChooseClientDialog extends StatelessWidget {
  final ClientModel? initClient;
  const ChooseClientDialog({this.initClient, super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(8),
        height: deviceSize.height * .8,
        width: deviceSize.width * .9,
        child: Column(
          children: [
            const Text('Выберите клиента:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Consumer(
                  builder: (context, ref, child) {
                    final clients = ref.watch(clientsProvider);
                    final currentClient = ref.watch(currentClientProvider(initClient: initClient));

                    return clients.when(
                      data: (clients) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 4),
                          itemCount: clients.length + 1,
                          itemBuilder: (context, index) {
                            if (index == clients.length) {
                              return TextButton(
                                onPressed: () {},
                                child: const Text('Добавить клиента'),
                              );
                            }
                            final isChosen = currentClient?.id == clients[index].id;
                            return GestureDetector(
                              onTap: () {
                                ref.read(currentClientProvider(initClient: initClient).notifier).client = clients[index];
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isChosen ? Colors.blue : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(
                                      clients[index].name,
                                      style: TextStyle(color: isChosen ? Colors.white : Colors.black),
                                    ),
                                    Text(
                                      clients[index].phone,
                                      style: TextStyle(color: isChosen ? Colors.white : Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      error: (e, s) => const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(onPressed: context.pop, child: const Text('Закрыть'))
          ],
        ),
      ),
    );
  }
}
