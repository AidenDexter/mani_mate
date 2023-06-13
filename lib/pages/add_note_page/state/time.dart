import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time.g.dart';

@riverpod
class BeginDate extends _$BeginDate {
  @override
  DateTime? build() => null;

  set date(DateTime value) => state = value;
}

@riverpod
class EndDate extends _$EndDate {
  @override
  DateTime? build() => null;

  set date(DateTime value) => state = value;
}
