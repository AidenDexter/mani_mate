import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../widgets/current_date_app_bar.dart';
import 'components/add_record_button.dart';
import 'components/add_records_list.dart';
import 'components/choose_client_dialog.dart';
import 'state/current_client.dart';
import 'state/time.dart';

final _noteController = TextEditingController();
final _priceController = TextEditingController();

class AddRecordPage extends ConsumerWidget {
  final DateTime? beginDateTime;
  const AddRecordPage(this.beginDateTime, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentClient = ref.watch(currentClientProvider);
    final beginDate = ref.watch(beginDateProvider(beginDateTime));
    final endDate = ref.watch(endDateProvider(beginDateTime?.add(const Duration(minutes: 30))));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CurrentDateAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const ChooseClientDialog(),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 236, 236, 236), borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Выбранный клиент: ${currentClient == null ? '' : currentClient.name}'),
                    ),
                    Icon(
                      Icons.edit,
                      color: Colors.black.withOpacity(.6),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (currentClient != null) ...[
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final deviceSize = MediaQuery.of(context).size;
                      return Material(
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: context.pop,
                            ),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  color: Colors.white,
                                  height: deviceSize.height * .8,
                                  width: deviceSize.width * .9,
                                  child: AddRecordsList(beginDateTime),
                                ),
                              ),
                            ),
                            Positioned(
                              top: deviceSize.height * .06,
                              right: deviceSize.width * .025,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  onPressed: context.pop,
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 236, 236), borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                            'Time: ${beginDate != null ? '${DateFormat('HH:mm').format(beginDate)} - ' : ''}${endDate != null ? DateFormat('HH:mm').format(endDate) : ''}'),
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.black.withOpacity(.6),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (beginDate != null && endDate != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration:
                      BoxDecoration(color: Colors.blue.withOpacity(.23), borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'Цена'),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration:
                        BoxDecoration(color: Colors.blue.withOpacity(.23), borderRadius: BorderRadius.circular(20)),
                    child: TextField(
                      controller: _noteController,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Текст заметки...'),
                    ),
                  ),
                ),
              ]
            ]
          ],
        ),
      ),
      floatingActionButton: AddRecordButton(_noteController, _priceController, beginDateTime),
    );
  }
}
