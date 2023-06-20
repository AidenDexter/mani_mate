import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../models/note_model.dart';
import '../../../providers/notes.dart';

class NoteWidget extends ConsumerWidget {
  const NoteWidget({super.key, required this.blockNotes, required this.time});

  final List<NoteModel> blockNotes;
  final DateTime time;

  void _showNoteContextMenu(TapDownDetails position, BuildContext context, WidgetRef ref) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = renderBox.globalToLocal(position.globalPosition);
    final RenderObject? overlay = Overlay.of(context).context.findRenderObject();
    final widgetPosition = (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(tapPosition.dx + widgetPosition.dx, tapPosition.dy + widgetPosition.dy, 0, 0),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width, overlay.paintBounds.size.height),
      ),
      items: [
        const PopupMenuItem(
          value: 'delete',
          child: Text('delete'),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Text('edit'),
        ),
      ],
    ).then((value) {
      switch (value) {
        case 'delete':
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Вы действительно хотите удалить эту запись?',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      Text('Текст: ${blockNotes.first.text ?? ''}'),
                      Text(
                          'Время: ${'${DateFormat('HH:mm').format(blockNotes.first.startDate)} - '}${DateFormat('HH:mm').format(blockNotes.first.endDate)}'),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(onPressed: context.pop, child: const Text('Отмена')),
                          ElevatedButton(
                              onPressed: () {
                                ref.read(notesProvider.notifier).deleteNoteById(blockNotes.first.id);
                                context.pop();
                              },
                              child: const Text('Удалить')),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        case 'edit':
          context.push('/edit_note', extra: blockNotes.first);
      }
    });
  }

  void _showAddContextMenu(TapDownDetails position, BuildContext context, WidgetRef ref) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = renderBox.globalToLocal(position.globalPosition);
    final RenderObject? overlay = Overlay.of(context).context.findRenderObject();
    final widgetPosition = (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(tapPosition.dx + widgetPosition.dx, tapPosition.dy + widgetPosition.dy, 0, 0),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width, overlay.paintBounds.size.height),
      ),
      items: [
        const PopupMenuItem(
          value: 'add',
          child: Text('add'),
        ),
      ],
    ).then((value) {
      switch (value) {
        case 'add':
          context.push('/add_note', extra: time);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTapDown: (position) => blockNotes.isNotEmpty
          ? _showNoteContextMenu(position, context, ref)
          : _showAddContextMenu(position, context, ref),
      child: Container(
        decoration: BoxDecoration(
          color: blockNotes.isNotEmpty ? noteBodyColor : Colors.white,
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.black.withOpacity(.1), width: .2),
          ),
        ),
        child: blockNotes.isNotEmpty && blockNotes.first.startDate == time
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
      ),
    );
  }
}
