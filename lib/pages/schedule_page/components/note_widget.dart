import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants.dart';
import '../../../models/note_model.dart';
import '../../../providers/notes.dart';

class NoteWidget extends ConsumerWidget {
  NoteWidget({super.key, required this.blockNotes, required this.time});

  final List<NoteModel> blockNotes;
  final DateTime time;
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPosition, BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    _tapPosition = renderBox.globalToLocal(tapPosition.globalPosition);
  }

  Future<void> _showContextMenu(BuildContext context, WidgetRef ref) async {
    final RenderObject? overlay = Overlay.of(context).context.findRenderObject();
    final widgetPosition = (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx + widgetPosition.dx, _tapPosition.dy + widgetPosition.dy, 0, 0),
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
    );

    switch (result) {
      case 'delete':
        ref.read(notesProvider.notifier).deleteNoteById(blockNotes.first.id);
      case 'edit':
        context.push('/add_note');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTapDown: (position) => blockNotes.isNotEmpty ? _getTapPosition(position, context) : {},
      onLongPress: () => blockNotes.isNotEmpty ? _showContextMenu(context, ref) : {},
      child: Container(
        color: blockNotes.isNotEmpty ? noteBodyColor : Colors.white,
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
