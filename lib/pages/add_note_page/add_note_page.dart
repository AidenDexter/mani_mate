import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/notes.dart';
import 'components/notes_list.dart';
import 'components/page_app_bar.dart';
import 'state/time.dart';
import 'state/verify.dart';

final _controller = TextEditingController();

class AddNotePage extends ConsumerWidget {
  const AddNotePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const PageAppBar(),
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
                    return Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.white,
                          height: deviceSize.height * .8,
                          width: deviceSize.width * .9,
                          child: const NotesList(),
                        ),
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
                            'Time: ${ref.watch(beginDateProvider) != null ? '${DateFormat('HH:mm').format(ref.watch(beginDateProvider)!)} - ' : ''}${ref.watch(endDateProvider) != null ? DateFormat('HH:mm').format(ref.watch(endDateProvider)!) : ''}')),
                    Icon(
                      Icons.edit,
                      color: Colors.black.withOpacity(.6),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (ref.watch(verifyDataProvider))
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: ref.watch(verifyDataProvider)
          ? FloatingActionButton(onPressed: () {
              ref.read(notesProvider.notifier).addNote(
                    startDate: ref.read(beginDateProvider)!,
                    endDate: ref.read(endDateProvider)!,
                    text: _controller.text,
                  );
              context.pop();
              _controller.clear();
            })
          : null,
    );
  }
}
