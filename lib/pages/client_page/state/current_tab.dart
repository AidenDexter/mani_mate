import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'current_tab.g.dart';

@riverpod
class CurrentTab extends _$CurrentTab {
  @override
  int build() => 0;

  set tab(int value) => state = value;
}
