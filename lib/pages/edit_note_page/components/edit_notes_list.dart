import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../constants.dart';
import '../../../models/note_model.dart';
import '../../../models/record_model.dart';
import '../../../providers/time.dart';
import '../../schedule_page/state/current_date.dart';
import '../../schedule_page/state/page_notes.dart';

class EditNotesList extends ConsumerWidget {
  final NoteModel note;
  const EditNotesList(this.note, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = ref.watch(currentDateProvider);
    final now = DateTime.now();
    final nowMinute = now.hour * 60 + now.minute;

    return ScrollablePositionedList.builder(
      initialScrollIndex: (nowMinute ~/ 30 - 2) % 48,
      itemCount: 48,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final time = DateTime(currentDate.year, currentDate.month, currentDate.day).add(Duration(minutes: 30 * index));

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(index % 2 == 0 ? 0 : 4),
                  decoration: BoxDecoration(
                    color: nowMinute ~/ 30 == index ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    DateFormat('HH:mm').format(time),
                    style: TextStyle(
                      fontSize: index % 2 == 0 ? 14 : 10,
                      color: nowMinute ~/ 30 == index ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              width: 1,
              decoration: BoxDecoration(color: Colors.black.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
            ),
            Expanded(
              flex: 5,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 40),
                child: Consumer(
                  builder: (context, ref, child) {
                    final notes = ref.watch(pageNotesProvider);
                    return notes.when(
                        data: (data) {
                          final blockNotes = data
                              .where((element) =>
                                  element.startDate.isBefore(time.add(const Duration(minutes: 1))) &&
                                  time.isBefore(element.endDate))
                              .toList();
                          final beginTime = ref.watch(beginDateProvider(note.startDate));
                          final endTime = ref.watch(endDateProvider(note.endDate));
                          if (blockNotes.isNotEmpty && blockNotes.first.id != note.id) {
                            final isRecord = blockNotes.first is RecordModel;
                            return Container(
                              decoration: BoxDecoration(
                                color: isRecord ? recordBodyColor : noteBodyColor,
                                border: const Border.symmetric(
                                  horizontal: BorderSide(color: Colors.black12, width: .3),
                                ),
                              ),
                              child: blockNotes.first.startDate == time
                                  ? Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        width: double.infinity,
                                        height: 5,
                                        color: isRecord ? recordHeaderColor : noteHeaderColor,
                                      ),
                                    )
                                  : null,
                            );
                          }

                          bool isChosen = false;
                          isChosen = beginTime!.isBefore(time.add(const Duration(minutes: 1))) && time.isBefore(endTime!);

                          return GestureDetector(
                            onTap: () {
                              if (time == endTime) {
                                ref.read(endDateProvider(note.endDate).notifier).date =
                                    time.add(const Duration(minutes: 30));
                                return;
                              }
                              if (time.add(const Duration(minutes: 30)) == beginTime) {
                                ref.read(beginDateProvider(note.startDate).notifier).date = time;
                                return;
                              }
                              ref.read(beginDateProvider(note.startDate).notifier).date = time;
                              ref.read(endDateProvider(note.endDate).notifier).date =
                                  time.add(const Duration(minutes: 30));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isChosen ? Colors.red.shade100 : null,
                                border: const Border.symmetric(
                                  horizontal: BorderSide(color: Colors.black12, width: .5),
                                ),
                              ),
                            ),
                          );
                        },
                        error: (error, stackTrace) => Center(child: Text(error.toString())),
                        loading: () => const SizedBox.shrink());
                  },
                ),
              ),
            ),
          ],
        );
      },
    ).animate().fade();
  }
}
