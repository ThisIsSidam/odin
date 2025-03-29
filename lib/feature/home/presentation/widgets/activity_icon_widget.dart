import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/data/models/activity.dart';

class ActivityIconWidget extends ConsumerWidget {
  const ActivityIconWidget({
    required this.icon,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  final ActivityIcon icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  static const double _kIconSize = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color color =
        foregroundColor ?? Theme.of(context).colorScheme.surface;
    late final Widget iconWidget;
    if (icon.isIconData) {
      iconWidget = Icon(
        icon.iconData,
        color: color,
        size: _kIconSize,
      );
    } else {
      iconWidget = Icon(
        Icons.question_mark,
        color: color,
        size: _kIconSize,
      );
    }

    if (onTap != null) {
      return IconButton(
        onPressed: onTap,
        icon: iconWidget,
        style: IconButton.styleFrom(
          foregroundColor: color,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
    }

    return backgroundColor == null
        ? iconWidget
        : Container(
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
