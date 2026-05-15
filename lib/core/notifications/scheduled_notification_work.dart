import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart' hide TaskStatus;
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/data/models/task_model.dart';
import 'package:devpaul_todo_app/core/firebase/firebase_options.dart';

const _dailyTaskId = 'daily_pending_notification';
const _periodicTaskId = 'periodic_due_check';
const _lastDailyKey = 'last_daily_notification_date';
const _notifiedTasksKey = 'notified_due_soon_tasks';
const _dailyChannelId = 'daily_pending_tasks';
const _urgentChannelId = 'urgent_due_soon';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      await _initializeServices();
      await _ensureAndroidChannels();

      switch (taskName) {
        case _dailyTaskId:
          await _runDailyPendingCheck();
        case _periodicTaskId:
          await _runPeriodicDueCheck();
      }
      return true;
    } catch (e, stack) {
      debugPrint('[Workmanager] Error in $taskName: $e\n$stack');
      return false;
    }
  });
}

Future<void> _initializeServices() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

Future<void> _ensureAndroidChannels() async {
  final localNotifications = FlutterLocalNotificationsPlugin();
  final androidPlugin =
      localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  if (androidPlugin == null) return;

  final channels = await androidPlugin.getNotificationChannels();
  final channelIds = channels?.map((c) => c.id).toSet() ?? <String>{};

  if (!channelIds.contains(_dailyChannelId)) {
    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        _dailyChannelId,
        'Tareas pendientes diarias',
        description: 'Resumen diario de tareas pendientes',
        importance: Importance.high,
      ),
    );
  }

  if (!channelIds.contains(_urgentChannelId)) {
    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        _urgentChannelId,
        'Tareas por vencer',
        description: 'Aviso de tarea por vencer',
        importance: Importance.max,
      ),
    );
  }
}

Future<List<Task>> _fetchPendingTasks() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];

  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('tasks')
      .where('status', whereIn: ['pending', 'inProgress'])
      .get();

  return snapshot.docs
      .map((doc) => TaskModel.fromSnapshot(doc))
      .toList();
}

Future<void> _runDailyPendingCheck() async {
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final lastDaily = prefs.getString(_lastDailyKey);
  if (lastDaily != null && DateTime.tryParse(lastDaily) != null) {
    final lastDate = DateTime.parse(lastDaily);
    if (DateTime(lastDate.year, lastDate.month, lastDate.day) == today) {
      return;
    }
  }

  final tasks = await _fetchPendingTasks();
  final pendingTasks = tasks.where((t) => t.status != TaskStatus.completed).toList();

  if (pendingTasks.isEmpty) return;

  final highPriority = pendingTasks.where((t) => t.priority == TaskPriority.high).length;
  final mediumPriority = pendingTasks.where((t) => t.priority == TaskPriority.medium).length;
  final lowPriority = pendingTasks.where((t) => t.priority == TaskPriority.low).length;

  final parts = <String>[];
  if (highPriority > 0) parts.add('$highPriority urgentes');
  if (mediumPriority > 0) parts.add('$mediumPriority medias');
  if (lowPriority > 0) parts.add('$lowPriority bajas');

  final localNotifications = FlutterLocalNotificationsPlugin();
  await localNotifications.show(
    1000,
    'Tienes ${pendingTasks.length} tareas pendientes',
    'Prioridad: ${parts.join(", ")}. ¡A organizar tu día!',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        _dailyChannelId,
        'Tareas pendientes diarias',
        channelDescription: 'Resumen diario de tareas pendientes',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(presentSound: true, presentBadge: true),
    ),
    payload: 'daily_summary',
  );

  await prefs.setString(_lastDailyKey, today.toIso8601String());
}

Future<void> _runPeriodicDueCheck() async {
  final tasks = await _fetchPendingTasks();
  final now = DateTime.now();
  final oneHourLater = now.add(const Duration(hours: 1));

  final prefs = await SharedPreferences.getInstance();
  final notifiedJson = prefs.getString(_notifiedTasksKey);
  final notifiedIds = notifiedJson != null
      ? (jsonDecode(notifiedJson) as List<dynamic>).cast<String>().toSet()
      : <String>{};

  final localNotifications = FlutterLocalNotificationsPlugin();
  final newNotified = <String>{...notifiedIds};

  for (final task in tasks) {
    if (task.status == TaskStatus.completed) continue;
    if (notifiedIds.contains(task.id)) continue;

    if (task.dueDate.isAfter(now) && task.dueDate.isBefore(oneHourLater)) {
      final minutesLeft = task.dueDate.difference(now).inMinutes;
      final message = minutesLeft <= 0
          ? '¡Esta tarea ya venció!'
          : 'Faltan $minutesLeft minutos para el vencimiento';

      await localNotifications.show(
        task.id.hashCode.abs() + 2000,
        '⏰ ${task.name}',
        message,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _urgentChannelId,
            'Tareas por vencer',
            channelDescription: 'Aviso de tarea por vencer',
            importance: Importance.max,
            priority: Priority.max,
          ),
          iOS: DarwinNotificationDetails(
            presentSound: true,
            presentBadge: true,
          ),
        ),
        payload: 'task:${task.id}',
      );

      newNotified.add(task.id);
    }
  }

  if (newNotified.length != notifiedIds.length) {
    await prefs.setString(_notifiedTasksKey, jsonEncode(newNotified.toList()));
  }
}

Future<void> scheduleDailyNotification() async {
  await Workmanager().cancelByUniqueName(_dailyTaskId);

  final now = DateTime.now();
  var scheduledTime = DateTime(now.year, now.month, now.day, 7, 0);

  if (now.isAfter(scheduledTime)) {
    scheduledTime = scheduledTime.add(const Duration(days: 1));
  }

  final initialDelay = scheduledTime.difference(now);

  await Workmanager().registerOneOffTask(
    _dailyTaskId,
    _dailyTaskId,
    initialDelay: initialDelay,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
    backoffPolicy: BackoffPolicy.linear,
    backoffPolicyDelay: const Duration(minutes: 10),
  );
}

Future<void> setupPeriodicDueCheck() async {
  await Workmanager().registerPeriodicTask(
    _periodicTaskId,
    _periodicTaskId,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}

Future<void> cancelAllScheduledWork() async {
  await Workmanager().cancelAll();
}

Future<void> clearNotifiedDueTasks() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_notifiedTasksKey);
}
