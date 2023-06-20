import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../models/note_model.dart';
import '../../../models/record_model.dart';
import '../../../providers/clients.dart';
import '../../../providers/notes.dart';
import '../../../providers/records.dart';

class NoteWidget extends ConsumerWidget {
  const NoteWidget({super.key, required this.note, required this.time});

  final NoteModel? note;
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
      if (value == 'delete') {
        note is RecordModel
            ? ref.read(recordsProvider.notifier).deleteRecordById(note!.id)
            : showDialog(
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
                          Text('Текст: ${note?.text ?? ''}'),
                          Text(
                              'Время: ${'${DateFormat('HH:mm').format(note!.startDate)} - '}${DateFormat('HH:mm').format(note!.endDate)}'),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(onPressed: context.pop, child: const Text('Отмена')),
                              ElevatedButton(
                                  onPressed: () {
                                    ref.read(notesProvider.notifier).deleteNoteById(note!.id);
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
      } else if (value == 'edit'){
        context.push('/edit_note', extra: note);
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
      onTapDown: (position) =>
          note != null ? _showNoteContextMenu(position, context, ref) : _showAddContextMenu(position, context, ref),
      child: Container(
        decoration: BoxDecoration(
          color: note != null
              ? note is RecordModel
                  ? recordBodyColor
                  : noteBodyColor
              : Colors.white,
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.black.withOpacity(.1), width: .2),
          ),
        ),
        child: note != null && note!.startDate == time
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 5,
                    color: note is RecordModel ? recordHeaderColor : noteHeaderColor,
                  ),
                  if (note is RecordModel)
                    Consumer(
                      builder: (context, ref, child) {
                        final record = note as RecordModel;
                        final clients = ref.watch(clientsProvider).value;
                        final currentClient = clients?.firstWhere((element) => element.id == record.clientId);
                        return currentClient == null
                            ? SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Text('Имя: ${currentClient.name}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Text('Телефон: ${currentClient.phone}'),
                                  ),
                                ],
                              );
                      },
                    ),
                  if (note!.text != null && note!.text!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(note!.text!),
                    ),
                ],
              )
            : null,
      ),
    );
  }
}
