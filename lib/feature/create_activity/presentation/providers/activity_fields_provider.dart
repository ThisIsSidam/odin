import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/entities/activity_entity.dart';

part 'generated/activity_fields_provider.g.dart';

@Riverpod(keepAlive: true)
class ActivityFieldsNotifier extends _$ActivityFieldsNotifier {
  @override
  ActivityEntity build() {
    return ActivityEntity(
      name: '',
      description: null,
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

  set updateActivityState(ActivityEntity activity) {
    state = activity;
  }

  void clearState() => state = ActivityEntity(
        name: '',
        description: null,
      );
}
