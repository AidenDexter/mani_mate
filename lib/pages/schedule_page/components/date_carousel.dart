import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:intl/intl.dart';

import '../state/current_date.dart';

class DateCarousel extends ConsumerStatefulWidget {
  const DateCarousel({super.key});

  @override
  ConsumerState<DateCarousel> createState() => _DateCarouselState();
}

class _DateCarouselState extends ConsumerState<DateCarousel> {
  late final InfiniteScrollController controller;
  bool showLeftTurnBackButton = false;
  bool showRightTurnBackButton = false;
  @override
  void initState() {
    controller = InfiniteScrollController();
    controller.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    if (controller.offset.abs() < 400 && (showLeftTurnBackButton != false || showRightTurnBackButton != false)) {
      setState(() {
        showLeftTurnBackButton = false;
        showRightTurnBackButton = false;
      });
    } else if (controller.offset <= -400 && (showLeftTurnBackButton != false || showRightTurnBackButton != true)) {
      setState(() {
        showLeftTurnBackButton = false;
        showRightTurnBackButton = true;
      });
    } else if (controller.offset >= 400 && (showLeftTurnBackButton != true || showRightTurnBackButton != false)) {
      setState(() {
        showLeftTurnBackButton = true;
        showRightTurnBackButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          InfiniteCarousel.builder(
            controller: controller,
            itemCount: 3,
            itemExtent: 80,
            itemBuilder: (context, itemIndex, realIndex) {
              final day = today.add(Duration(days: realIndex));
              final currentDate = ref.watch(currentDateProvider);
              final isThisCurrentDate =
                  day.day == currentDate.day && day.month == currentDate.month && day.year == currentDate.year;

              return Column(
                children: [
                  Container(
                    height: 5,
                    width: 10,
                    decoration: BoxDecoration(
                      color: realIndex == 0 ? Colors.blue : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(currentDateProvider.notifier).date = day;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isThisCurrentDate ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            if (!isThisCurrentDate) BoxShadow(color: Colors.black.withOpacity(realIndex < 0 ? 0.05 : .2), blurRadius: 3)
                          ],
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                DateFormat('EEEE', 'ru').format(day),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: isThisCurrentDate
                                        ? Colors.white
                                        : Colors.black.withOpacity(realIndex < 0 ? 0.5 : 1)),
                              ),
                            ),
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: isThisCurrentDate
                                      ? Colors.white
                                      : Colors.black.withOpacity(realIndex < 0 ? 0.5 : 1)),
                            ),
                            Text(
                              DateFormat('MMMM', 'ru').format(day),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: isThisCurrentDate
                                      ? Colors.white
                                      : Colors.black.withOpacity(realIndex < 0 ? 0.5 : 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (showLeftTurnBackButton)
            Align(
              alignment: Alignment.centerLeft,
              child: RawMaterialButton(
                onPressed: () => controller.animateToItem(0, curve: Curves.easeInOut),
                fillColor: Colors.blue,
                padding: const EdgeInsets.all(4),
                shape: const CircleBorder(),
                constraints: const BoxConstraints(minWidth: 60.0, minHeight: 36.0),
                child: const Icon(
                  Icons.arrow_circle_left_outlined,
                  size: 35.0,
                  color: Colors.white,
                ),
              ),
            ).animate().fade(duration: const Duration(milliseconds: 150)),
          if (showRightTurnBackButton)
            Align(
              alignment: Alignment.centerRight,
              child: RawMaterialButton(
                onPressed: () => controller.animateToItem(0, curve: Curves.easeInOut),
                fillColor: Colors.blue,
                padding: const EdgeInsets.all(4),
                shape: const CircleBorder(),
                constraints: const BoxConstraints(minWidth: 60.0, minHeight: 36.0),
                child: const Icon(
                  Icons.arrow_circle_right_outlined,
                  size: 35.0,
                  color: Colors.white,
                ),
              ),
            ).animate().fade(duration: const Duration(milliseconds: 150)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
