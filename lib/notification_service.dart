import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'models/note_model.dart';
import 'models/record_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings = const AndroidInitializationSettings('logo');

  Future<void> init() async {
    final InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.max,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> scheduleNoteNotification(final NoteModel note) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'Запланированные дела',
      'Запланированные дела',
      importance: Importance.max,
      priority: Priority.max,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      note.timeOfCreate,
      'Запланирована задача!',
      note.text,
      tz.TZDateTime.from(note.startDate.add(const Duration(minutes: -10)), tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleRecordNotification(final RecordModel note, final String clientName) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'Клиенты',
      'Клиенты',
      importance: Importance.max,
      priority: Priority.max,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      note.timeOfCreate,
      'Скоро клиент!',
      '$clientName! С ${DateFormat('HH:mm', 'ru').format(note.startDate)}-${DateFormat('HH:mm', 'ru').format(note.endDate)}',
      tz.TZDateTime.from(note.startDate.add(const Duration(minutes: -10)), tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> deleteNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
