import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../constants.dart';
import '../../schedule_page/state/current_date.dart';
import '../../schedule_page/state/page_notes.dart';
import '../state/time.dart';

class AddRecordsList extends ConsumerWidget {
  const AddRecordsList(this.beginDateTime, {super.key});
  final DateTime? beginDateTime;

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
                  padding: EdgeInsets.all(nowMinute ~/ 30 == index ? 0 : 8),
                  decoration: BoxDecoration(
                    color: nowMinute ~/ 30 == index ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    DateFormat('HH:mm').format(time),
                    style: TextStyle(
                      fontSize: index % 2 == 0 ? 16 : 12,
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
                          if (blockNotes.isNotEmpty) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: noteBodyColor,
                                border: Border.symmetric(
                                  horizontal: BorderSide(color: Colors.black12, width: .3),
                                ),
                              ),
                              child: blockNotes.first.startDate == time
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 5,
                                          color: noteHeaderColor,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Text(blockNotes.first.text ?? 'bad'),
                                        ),
                                      ],
                                    )
                                  : null,
                            );
                          }

                          final beginTime = ref.watch(beginDateProvider(beginDateTime));
                          final endTime = ref.watch(endDateProvider(beginDateTime?.add(const Duration(minutes: 30))));
                          bool isChosen = false;
                          if (beginTime != null && endTime != null) {
                            isChosen =
                                beginTime.isBefore(time.add(const Duration(minutes: 1))) && time.isBefore(endTime);
                          }
                          return GestureDetector(
                            onTap: () {
                              if (beginTime == null && endTime == null) {
                                ref.read(beginDateProvider(beginDateTime).notifier).date = time;
                                ref
                                    .read(endDateProvider(beginDateTime?.add(const Duration(minutes: 30))).notifier)
                                    .date = time.add(const Duration(minutes: 30));
                                return;
                              }

                              if (time == endTime) {
                                ref
                                    .read(endDateProvider(beginDateTime?.add(const Duration(minutes: 30))).notifier)
                                    .date = time.add(const Duration(minutes: 30));
                                return;
                              }

                              if (time.add(const Duration(minutes: 30)) == beginTime) {
                                ref.read(beginDateProvider(beginDateTime).notifier).date = time;
                                return;
                              }

                              ref.read(beginDateProvider(beginDateTime).notifier).date = time;
                              ref.read(endDateProvider(beginDateTime?.add(const Duration(minutes: 30))).notifier).date =
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
