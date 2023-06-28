// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'note_model.g.dart';

@immutable
@HiveType(typeId: 2)
class NoteModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime startDate;
  @HiveField(2)
  final DateTime endDate;
  @HiveField(3)
  final String? text;
  @HiveField(6)
  final int timeOfCreate;

  const NoteModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    this.text,
    required this.timeOfCreate,
  });

  NoteModel copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    String? text,
    int? timeOfCreate,
  }) {
    return NoteModel(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      text: text ?? this.text,
      timeOfCreate: timeOfCreate ?? this.timeOfCreate,
    );
  }
}
