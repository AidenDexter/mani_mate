import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../state/current_date.dart';
import '../state/page_notes.dart';
import 'note_widget.dart';

class NotesList extends ConsumerWidget {
  const NotesList({super.key});

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

        return Opacity(
          opacity: now.isAfter(time.add(const Duration(minutes: 30))) ? .5 : 1,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(index % 2 == 0 ? 8 : 4),
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
                  width: 1,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(width: 4),
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
                              return NoteWidget(
                                blockNotes: blockNotes,
                                time: time,
                              );
                            },
                            error: (error, stackTrace) => Center(child: Text(error.toString())),
                            loading: () => const SizedBox.shrink());
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).animate().fade();
  }
}
