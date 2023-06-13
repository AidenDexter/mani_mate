import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'components/date_carousel.dart';
import 'components/notes_list.dart';

class SchedulePage extends ConsumerWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Р',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const DateCarousel(),
          const SizedBox(height: 8),
          Expanded(
            child: Stack(
              children: [
                const NotesList(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  height: 40,
                  width: double.infinity,
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: CircularMenu(
        alignment: Alignment.bottomRight,
        animationDuration: const Duration(milliseconds: 300),
        radius: 40,
        toggleButtonSize: 30,
        toggleButtonMargin: 0,
        startingAngleInRadian: 3.0,
        endingAngleInRadian: 4.5,
        curve: Curves.easeInOut,
        toggleButtonBoxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(.5),
            blurRadius: 10,
          ),
        ],
        toggleButtonAnimatedIconData: AnimatedIcons.add_event,
        items: [
          CircularMenuItem(
            icon: Icons.person,
            onTap: () => context.push('/add_note'),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(.5),
                blurRadius: 10,
              ),
            ],
          ),
          CircularMenuItem(
            icon: Icons.note_alt_outlined,
            onTap: () => context.push('/add_note'),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(.5),
                blurRadius: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
