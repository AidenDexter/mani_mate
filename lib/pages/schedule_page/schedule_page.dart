import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mani_mate/pages/schedule_page/state/current_date.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:mani_mate/providers/notes.dart';

import 'components/notes_list.dart';

class SchedulePage extends ConsumerWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: InfiniteCarousel.builder(
              itemCount: 3,
              itemExtent: 70,
              center: true,
              itemBuilder: (context, itemIndex, realIndex) {
                final day = today.add(Duration(days: realIndex));
                final currentDate = ref.watch(currentDateProvider);
                final isCurrentDateToday =
                    day.day == currentDate.day && day.month == currentDate.month && day.year == currentDate.year;
                return GestureDetector(
                  onTap: () {
                    ref.read(currentDateProvider.notifier).date = day;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCurrentDateToday ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(5),
                    height: 50,
                    width: 70,
                    alignment: Alignment.center,
                    child: Text('${day.day} ${day.month}'),
                  ),
                );
              },
            ),
          ),
          const NotesList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          final currentDate = ref.read(currentDateProvider);
          ref.read(notesProvider.notifier).addNote(
                startDate: currentDate,
                endDate: currentDate.add(const Duration(hours: 2)),
              );
        },
      ),
    );
  }
}
