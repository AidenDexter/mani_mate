import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_date.g.dart';

@Riverpod(keepAlive: true)
class CurrentDate extends _$CurrentDate {
  @override
  DateTime build() => DateTime.now();

  set date(DateTime value) => state = value;
}
