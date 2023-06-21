import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants.dart';
import '../../../models/note_model.dart';
import '../../../models/record_model.dart';
import '../../../providers/clients.dart';
import '../dialogs/delete_confirm_dialog.dart';
import '../dialogs/edit_record_dialog.dart';

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
        showDialog(
          context: context,
          builder: (context) {
            return DeleteConfirmDialog(note: note!);
          },
        );
      } else if (value == 'edit') {
        note is RecordModel
            ? showDialog(context: context, builder: (context) => EditRecordDialog(note as RecordModel))
            : context.push('/edit_note', extra: note);
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
          value: 'note',
          child: Text('Заметка'),
        ),
        const PopupMenuItem(
          value: 'client',
          child: Text('Клиент'),
        ),
      ],
    ).then((value) {
      switch (value) {
        case 'note':
          context.push('/add_note', extra: time);
        case 'client':
          context.push('/add_record', extra: time);
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
                            ? const SizedBox.shrink()
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
