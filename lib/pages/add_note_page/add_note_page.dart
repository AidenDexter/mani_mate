import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../widgets/current_date_app_bar.dart';
import 'components/add_note_button.dart';
import 'components/add_notes_list.dart';
import 'state/time.dart';

final _controller = TextEditingController();

class AddNotePage extends StatelessWidget {
  final DateTime? beginDateTime;
  const AddNotePage(this.beginDateTime, {super.key});

  @override
  Widget build(BuildContext context) {
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
                                child: AddNotesList(beginDateTime),
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
                      child: Consumer(
                        builder: (context, ref, child) {
                          final beginDate = ref.watch(beginDateProvider(beginDateTime));
                          final endDate = ref.watch(endDateProvider(beginDateTime?.add(Duration(minutes: 30))));
                          return Text(
                              'Time: ${beginDate != null ? '${DateFormat('HH:mm').format(beginDate)} - ' : ''}${endDate != null ? DateFormat('HH:mm').format(endDate) : ''}');
                        },
                      ),
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(.23), borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'Текст заметки...'),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: AddNoteButton(_controller, beginDateTime),
    );
  }
}
