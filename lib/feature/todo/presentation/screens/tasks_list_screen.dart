import 'package:flutter/material.dart';

import '../../data/task.dart';
import '../widgets/task_card.dart';
import 'task_screen.dart.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = mockTasks;

  // Group tasks by date
  Map<String, List<Task>> _groupTasksByDate() {
    final Map<String, List<Task>> grouped = <String, List<Task>>{};

    for (final Task task in tasks) {
      final String date = _formatDate(task.scheduleTime);
      if (!grouped.containsKey(date)) {
        grouped[date] = <Task>[];
      }
      grouped[date]!.add(task);
    }

    return grouped;
  }

  String _formatDate(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime tomorrow = today.add(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _addNewTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Task>> groupedTasks = _groupTasksByDate();
    final List<String> sortedDates = groupedTasks.keys.toList()
      ..sort((String a, String b) {
        if (a == 'Today') return -1;
        if (b == 'Today') return 1;
        if (a == 'Tomorrow') return -1;
        if (b == 'Tomorrow') return 1;
        return a.compareTo(b);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet. Add your first task!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedDates.length,
              itemBuilder: (BuildContext context, int index) {
                final String date = sortedDates[index];
                final List<Task> tasksForDate = groupedTasks[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    ...tasksForDate.map((Task task) => TaskCard(task: task)),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  TaskScreen(onTaskCreated: _addNewTask),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
