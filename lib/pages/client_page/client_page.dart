import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/clients.dart';
import 'state/current_tab.dart';
import 'state/page_client.dart';

class ClientAndServicesPage extends ConsumerWidget {
  final String clientId;
  const ClientAndServicesPage(this.clientId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(pageClientProvider(clientId));
    final currentTab = ref.watch(currentTabProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
                width: 65,
                height: 65,
                child: const Icon(
                  Icons.face_retouching_natural_sharp,
                  color: Color.fromARGB(255, 1, 1, 1),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'тел: ${client.phone}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                    onPressed: () {
                      context.pop();
                      ref.read(clientsProvider.notifier).deleteById(clientId);
                    },
                    icon: const Icon(Icons.delete)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton(
                    onPressed: () {
                      showDialog(
                        barrierColor: Colors.transparent,
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 50),
                            color: Colors.white,
                            child: Material(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const TextField(),
                                    const TextField(),
                                    const TextField(),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: context.pop,
                                          child: const Text('close'),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed: () {
                                            ref
                                                .read(clientsProvider.notifier)
                                                .updateClient(client.copyWith(name: 'updated'));
                                            context.pop();
                                          },
                                          child: const Text('update'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit)),
              ),
            ],
          ),
          SizedBox(
            height: 36,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(currentTabProvider.notifier).tab = 0;
                    },
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('История'),
                          const SizedBox(height: 2),
                          AnimatedContainer(
                            decoration: const BoxDecoration(
                                color: Colors.blue, borderRadius: BorderRadius.vertical(top: Radius.circular(2))),
                            duration: const Duration(milliseconds: 150),
                            height: currentTab == 0 ? 4 : 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(currentTabProvider.notifier).tab = 1;
                    },
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Заметки'),
                          const SizedBox(
                            height: 2,
                          ),
                          AnimatedContainer(
                            decoration: const BoxDecoration(
                                color: Colors.blue, borderRadius: BorderRadius.vertical(top: Radius.circular(2))),
                            duration: const Duration(milliseconds: 150),
                            height: currentTab == 1 ? 4 : 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
