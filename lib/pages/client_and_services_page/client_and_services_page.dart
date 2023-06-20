import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mani_mate/providers/clients.dart';

import 'add_client_dialog.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const AddClientDialog();
              });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.face_retouching_natural_sharp, color: Colors.black),
        title: const Text(
          'Clients and services',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final clients = ref.watch(clientsProvider);

                  return clients.when(
                    data: (data) => ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final client = data[index];
                        return SafeArea(
                          child: Card(
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 28),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        width: 65,
                                        height: 65,
                                        child: const Icon(
                                          Icons.face_retouching_natural_sharp,
                                          color: Color.fromARGB(255, 1, 1, 1),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          client.name,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          'phone:${client.phone}',
                                          style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),
                                        ),
                                        Text(
                                          'Посл. посещение: 12 мая 2023 г.',
                                          style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: IconButton(
                                        icon: const Icon(Icons.arrow_forward_ios_outlined),
                                        onPressed: () {
                                          context.pushNamed('client_info', pathParameters: {'client_id': client.id});
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => const CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
