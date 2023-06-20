import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'note_model.dart';

part 'record_model.g.dart';

@immutable
@HiveType(typeId: 3)
class RecordModel extends NoteModel {
  @HiveField(4)
  final String clientId;
  @HiveField(5)
  final int? price;

  const RecordModel({
    required String id,
    required this.clientId,
    required DateTime startDate,
    required DateTime endDate,
    this.price,
    String? text,
  }) : super(
          id: id,
          startDate: startDate,
          endDate: endDate,
          text: text,
        );
}
