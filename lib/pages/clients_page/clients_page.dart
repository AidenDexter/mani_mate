import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/clients.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final clients = ref.watch(clientsProvider);

        return clients.when(
          data: (data) => ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final client = data[index];
              return Column(
                children: [
                  Text(client.id),
                  Text(client.name),
                  Text(client.phone),
                  Text(client.note),
                  IconButton(
                      onPressed: () {
                        ref.read(clientsProvider.notifier).deleteById(client.id);
                      },
                      icon: const Icon(Icons.delete)),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Material(
                              child: Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(30),
                                child: Column(
                                  children: [
                                    const TextField(),
                                    const TextField(),
                                    const TextField(),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: context.pop,
                                          child: const Text('close'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            ref.read(clientsProvider.notifier).updateClient(client.copyWith(name: 'updated'));
                                            context.pop();
                                          },
                                          child: const Text('update'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit)),
                  const SizedBox(height: 30),
                ],
              );
            },
          ),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        );
      },
    );
  }
}
