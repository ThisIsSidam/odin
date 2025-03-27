import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/data/models/activity.dart';

class ActivityIconWidget extends ConsumerWidget {
  const ActivityIconWidget({
    required this.icon,
    this.onTap,
    this.backgroundColor,
    super.key,
  });

  final ActivityIcon icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  static const double _kIconSize = 28;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final Widget iconWidget;
    if (icon.isIconData) {
      iconWidget = Icon(
        icon.iconData,
        color: Colors.white,
        size: _kIconSize,
      );
    } else {
      iconWidget = const Icon(
        Icons.question_mark,
        color: Colors.white,
        size: _kIconSize,
      );
    }

    if (onTap != null) {
      return IconButton(
        onPressed: onTap,
        icon: iconWidget,
        style: IconButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: iconWidget,
    );
  }
}
