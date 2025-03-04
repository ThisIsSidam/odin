import 'package:flutter/material.dart';

import '../feature/create_activity/presentation/screens/create_activity_screen.dart';
import '../feature/home/presentation/screens/home_screen.dart';
import 'app_routes.dart';

Map<String, WidgetBuilder> routeBuilder() {
  return <String, WidgetBuilder>{
    AppRoutes.home.path: (_) => const HomeScreen(),
  };
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final String? args = settings.arguments as String?;
  if (settings.name == AppRoutes.activity.path) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) {
        if (args == null) return const ActivityScreen();
        final int? id = int.tryParse(args);
        return ActivityScreen(id: id);
      },
    );
  }
  return null;
}
