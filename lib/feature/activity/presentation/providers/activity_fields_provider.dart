import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_icons_catalog/flutter_icons_catalog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../../../../core/data/models/activity.dart';
import '../../../../core/extensions/list_ext.dart';

part 'generated/activity_fields_provider.g.dart';

@Riverpod(keepAlive: true)
class ActivityFieldsNotifier extends _$ActivityFieldsNotifier {
  @override
  ActivityEntity build() {
    return ActivityEntity(
      name: '',
      description: null,
      colorHex: (Colors.primaries.pickRandom ?? Colors.blue).toHexString(),
    );
  }

  set productivityLevel(int value) {
    state = state.copyWith(
      productivityLevel: value,
    );
  }

  set id(int value) {
    state = state.copyWith(id: value);
  }

  set name(String value) {
    state = state.copyWith(name: value);
  }

  set description(String? value) {
    state = state.copyWith(description: value);
  }

  set colorHex(String? value) {
    state = state.copyWith(colorHex: value);
  }

  set hidden(bool value) {
    state = state.copyWith(hidden: value);
  }

  set icon(ActivityIcon icon) {
    state = state.copyWith(
      iconType: icon.iconType,
      iconName:
          icon.iconData == null ? null : IconsCatalog().getName(icon.iconData!),
    );
  }

  set updateActivityState(ActivityEntity activity) {
    state = activity;
  }

  void clearState() => state = ActivityEntity(
        name: '',
        description: null,
        colorHex: (Colors.primaries.pickRandom ?? Colors.blue).toHexString(),
      );
}
