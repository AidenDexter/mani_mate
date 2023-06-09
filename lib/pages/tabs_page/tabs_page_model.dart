import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabsPageModelProvider = StateNotifierProvider<TabsPageModel, int>((ref) => TabsPageModel(0));

class TabsPageModel extends StateNotifier<int> {
  TabsPageModel(super.state);

  set setPosition(value) => state = value;
}
