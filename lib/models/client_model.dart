import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'client_model.g.dart';

@immutable
@HiveType(typeId: 1)
class ClientModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String note;

  const ClientModel(
    this.id,
    this.name,
    this.phone,
    this.note,
  );

  @override
  String toString() {
    return '{id: $id, name: $name, phone: $phone, note: $note}';
  }

  ClientModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? note,
  }) {
    return ClientModel(
      id ?? this.id,
      name ?? this.name,
      phone ?? this.phone,
      note ?? this.note,
    );
  }
}
