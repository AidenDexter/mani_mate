import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:intl/intl.dart';

import '../state/current_date.dart';

class DateCarousel extends ConsumerWidget {
  const DateCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    return SizedBox(
      height: 65,
      child: InfiniteCarousel.builder(
        itemCount: 3,
        itemExtent: 75,
        itemBuilder: (context, itemIndex, realIndex) {
          final day = today.add(Duration(days: realIndex));
          final currentDate = ref.watch(currentDateProvider);
          final isCurrentDateToday =
              day.day == currentDate.day && day.month == currentDate.month && day.year == currentDate.year;
          return GestureDetector(
            onTap: () {
              ref.read(currentDateProvider.notifier).date = day;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: isCurrentDateToday ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [if (!isCurrentDateToday) BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 5)],
              ),
              margin: const EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${day.day}',
                    style: TextStyle(fontSize: 22, color: isCurrentDateToday ? Colors.white : Colors.black),
                  ),
                  Text(
                    DateFormat('MMMM', 'ru').format(day),
                    style: TextStyle(fontSize: 12, color: isCurrentDateToday ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
