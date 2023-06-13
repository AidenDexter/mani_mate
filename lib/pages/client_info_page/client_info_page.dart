import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/clients.dart';
import 'state/current_tab.dart';

class ClientInfoPage extends ConsumerWidget {
  final String clientId;
  const ClientInfoPage(this.clientId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientsProvider);
    final currentTab = ref.watch(currentTabProvider);
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
            onPressed: () {
              context.push('/clients');
            },
          ),
        ),
        body: Column(
          children: [
            Text(clientId),
            Row(
              children: [
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                  width: 65,
                  height: 65,
                  child: const Icon(
                    Icons.face_retouching_natural_sharp,
                    color: Color.fromARGB(255, 1, 1, 1),
                  ),
                ),
                // Text(ref.read(clientsProvider).),
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
                            SizedBox(
                              height: 2,
                            ),
                            AnimatedContainer(
                              decoration: BoxDecoration(
                                  color: Colors.blue, borderRadius: BorderRadius.vertical(top: Radius.circular(2))),
                              duration: Duration(milliseconds: 150),
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
                            SizedBox(
                              height: 2,
                            ),
                            AnimatedContainer(
                              decoration: BoxDecoration(
                                  color: Colors.blue, borderRadius: BorderRadius.vertical(top: Radius.circular(2))),
                              duration: Duration(milliseconds: 150),
                              height: currentTab == 1 ? 4 : 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
