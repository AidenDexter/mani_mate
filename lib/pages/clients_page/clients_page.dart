import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mani_mate/providers/clients.dart';

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
                      icon: Icon(Icons.delete)),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Material(
                              child: Container(
                                color: Colors.white,
                                margin: EdgeInsets.all(30),
                                child: Column(
                                  children: [
                                    TextField(),
                                    TextField(),
                                    TextField(),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: context.pop,
                                          child: Text('close'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            ref.read(clientsProvider.notifier).updateClient(client.copyWith(name: 'updated'));
                                            context.pop();
                                          },
                                          child: Text('update'),
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
                      icon: Icon(Icons.edit)),
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
