import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'time.dart';

part 'verify.g.dart';

// @riverpod
// class BeginDate extends _$BeginDate {
//   @override
//   DateTime? build() => null;

//   set date(DateTime value) => state = value;
// }

@riverpod
bool verifyData(VerifyDataRef ref) {
  final beginDate = ref.watch(beginDateProvider);
  final endDate = ref.watch(endDateProvider);
  return beginDate != null && endDate != null && beginDate.isBefore(endDate);
}
