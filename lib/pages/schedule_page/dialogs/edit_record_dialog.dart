import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../models/record_model.dart';
import '../../../providers/clients.dart';
import '../../../providers/records.dart';
import '../../../providers/time.dart';
import '../../add_record_page/components/choose_client_dialog.dart';
import '../../add_record_page/state/current_client.dart';
import '../components/edit_record_list.dart';

final _noteController = TextEditingController();
final _priceController = TextEditingController();

class EditRecordDialog extends ConsumerWidget {
  final RecordModel record;
  const EditRecordDialog(this.record, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(clientsProvider).value?.firstWhere((e) => e.id == record.clientId);
    final currentClient = ref.watch(currentClientProvider(initClient: client));
    final beginDate = ref.watch(beginDateProvider(record.startDate));
    final endDate = ref.watch(endDateProvider(record.endDate));
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Редактирование записи:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ChooseClientDialog(initClient: client),
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
                                child: EditRecordsList(record),
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
                          'Time: ${'${DateFormat('HH:mm').format(beginDate!)} - '}${DateFormat('HH:mm').format(endDate!)}'),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(.23), borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _priceController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'Цена'),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 100,
              decoration: BoxDecoration(color: Colors.blue.withOpacity(.23), borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _noteController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'Текст заметки...'),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  ref.read(recordsProvider.notifier).updateRecord(
                        record.copyWithField(
                          clientId: currentClient!.id,
                          startDate: beginDate,
                          endDate: endDate,
                          price: _priceController.text.isEmpty ? null : int.tryParse(_priceController.text),
                          text: _noteController.text,
                        ),
                      );
                  context.pop();
                },
                child: const Text('Подтвердить'))
          ],
        ),
      ),
    );
  }
}
