import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time.g.dart';

@riverpod
class BeginDate extends _$BeginDate {
  @override
  DateTime? build(DateTime? initDate) {
    return initDate;
  }

  set date(DateTime value) {
    state = value;
  }
}

@riverpod
class EndDate extends _$EndDate {
  @override
  DateTime? build(DateTime? initDate) => initDate;

  set date(DateTime value) {
    state = value;
  }
}
