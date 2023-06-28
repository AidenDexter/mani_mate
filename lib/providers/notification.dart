import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../notification_service.dart';

part 'notification.g.dart';

@Riverpod(keepAlive: true)
Future<NotificationService> notification(NotificationRef ref) async {
  final notification = NotificationService();
  await notification.init();

  return notification;
}
