// Task Card Widget
import 'package:flutter/material.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../../data/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ActivityButton(activity: task.activity),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${task.scheduleTime.hour}:${task.scheduleTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
