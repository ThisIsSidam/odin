import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'core/providers/global_providers.dart';
import 'core/theme/theme.dart';
import 'feature/home/presentation/screens/dashboard_screen.dart';
import 'objectbox.g.dart';
import 'router/route_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Directory dir = await getApplicationDocumentsDirectory();
  final Store store = Store(
    getObjectBoxModel(),
    directory: path.join(
      dir.path,
      'objectbox-activity-store',
    ),
  );
  runApp(
    ProviderScope(
      overrides: <Override>[
        objectboxStoreProvider.overrideWithValue(store),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DashboardScreen(),
      routes: routeBuilder(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
