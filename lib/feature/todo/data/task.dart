// Activity class to represent different types of activities
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/data/models/activity.dart';

class Task {
  final String id;
  final String title;
  final Activity activity;
  final DateTime scheduleTime;
  final bool isCompleted;

  Task({
    required this.title,
    required this.activity,
    required this.scheduleTime,
    this.isCompleted = false,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString() +
            Random().nextInt(1000).toString();
}

// Mock data for tasks
final List<Task> mockTasks = <Task>[
  Task(
    title: 'Morning Exercise',
    activity: const Activity(
      name: 'Exercise',
      id: 1,
      icon: ActivityIcon.icon(iconData: Icons.fitness_center),
      color: Colors.red,
      productivityLevel: 3,
    ),
    scheduleTime: DateTime.now().add(const Duration(hours: 1)),
  ),
  Task(
    title: 'Read a Book',
    activity: const Activity(
      name: 'Reading',
      id: 2,
      icon: ActivityIcon.icon(iconData: Icons.book),
      color: Colors.blue,
      productivityLevel: 2,
    ),
    scheduleTime: DateTime.now().add(const Duration(hours: 3)),
  ),
  Task(
    title: 'Project Meeting',
    activity: const Activity(
      name: 'Work',
      id: 3,
      icon: ActivityIcon.icon(iconData: Icons.work),
      color: Colors.green,
      productivityLevel: 4,
    ),
    scheduleTime: DateTime.now().add(const Duration(hours: 5)),
    isCompleted: true,
  ),
];
