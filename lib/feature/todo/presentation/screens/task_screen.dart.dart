import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/models/activity.dart';
import '../../../home/presentation/providers/activity_provider.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../data/task.dart';

// Create Task Screen
class TaskScreen extends ConsumerStatefulWidget {
  final Function(Task) onTaskCreated;

  const TaskScreen({required this.onTaskCreated, super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  Activity? _selectedActivity;
  DateTime _scheduleTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedActivity != null) {
      final Task newTask = Task(
        title: _titleController.text,
        activity: _selectedActivity!,
        scheduleTime: _scheduleTime,
      );

      widget.onTaskCreated(newTask);
      Navigator.pop(context);
    } else if (_selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an activity')),
      );
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduleTime),
    );

    if (pickedTime != null) {
      setState(() {
        _scheduleTime = DateTime(
          _scheduleTime.year,
          _scheduleTime.month,
          _scheduleTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _scheduleTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _scheduleTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _scheduleTime.hour,
          _scheduleTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Activity> activities = ref.watch(activityNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Activity Selection
              const Text(
                'Select Activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: activities
                    .map(
                      (Activity e) => ActivityButton(activity: e),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Schedule Time
              const Text(
                'Schedule Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.teal,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_scheduleTime.day}/${_scheduleTime.month}/${_scheduleTime.year}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _selectTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.access_time, color: Colors.teal),
                            const SizedBox(width: 8),
                            Text(
                              '${_scheduleTime.hour}:${_scheduleTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create Task',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
