import 'package:flutter/material.dart';

import '../feature/activity/presentation/screens/activity_screen.dart';
import '../feature/home/presentation/screens/home_screen.dart';
import 'app_routes.dart';

Map<String, WidgetBuilder> routeBuilder() {
  return <String, WidgetBuilder>{
    AppRoutes.home.path: (_) => const HomeScreen(),
    AppRoutes.activity.path: (_) => const ActivityScreen(),
  };
}
