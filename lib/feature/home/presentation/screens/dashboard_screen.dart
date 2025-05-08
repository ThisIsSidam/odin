import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../activity_logs/presentation/screens/activity_logs_screen.dart';
import '../../../settings/presentation/screens/settings.dart';
import '../../../stats/presentation/screens/stat_screen.dart';
import '../../../todo/presentation/screens/tasks_list_screen.dart';
import 'home_screen.dart';

@immutable
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultTabController(
      length: 5,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            TaskListScreen(),
            HomeScreen(),
            ActivityLogsScreen(),
            StatScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: <Tab>[
            Tab(
              icon: Icon(Icons.checklist),
              text: 'Tasks',
            ),
            Tab(
              icon: Icon(Icons.home),
              text: 'Home',
            ),
            Tab(
              icon: Icon(Icons.file_download_done_sharp),
              text: 'Logs',
            ),
            Tab(
              icon: Icon(Icons.bar_chart),
              text: 'Stats',
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
