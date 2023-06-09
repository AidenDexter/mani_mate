import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../providers/time.dart';

part 'verify.g.dart';

@riverpod
bool verifyData(VerifyDataRef ref, {DateTime? beginDateTime}) {
  final beginDate = ref.watch(beginDateProvider(beginDateTime));
  final endDate = ref.watch(endDateProvider(beginDateTime?.add(const Duration(minutes: 30))));
  return beginDate != null && endDate != null && beginDate.isBefore(endDate);
}
