import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../activity_logs/presentation/screens/activity_logs_screen.dart';
import 'home_screen.dart';

@immutable
class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  Widget _currentScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ActivityLogsScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<int> currentScreen = useState<int>(0);
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _currentScreen(currentScreen.value),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_download_done_sharp),
            label: 'Logs',
          ),
        ],
        currentIndex: currentScreen.value,
        onTap: (int index) {
          currentScreen.value = index;
        },
      ),
    );
  }
}
