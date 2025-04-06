import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/models/activity.dart';
import '../../data/entities/activity_log_entity.dart';

part 'generated/log_fields_provider.g.dart';

@riverpod
class LogFieldsNotifier extends _$LogFieldsNotifier {
  @override
  ActivityLogEntity build() {
    return ActivityLogEntity(
      startedAt: DateTime.now(),
      stoppedAt: DateTime.now(),
    );
  }

  set id(int value) {
    state = state.copyWith(id: value);
  }

  set startedAt(DateTime value) {
    state = state.copyWith(startedAt: value);
  }

  set stoppedAt(DateTime value) {
    state = state.copyWith(stoppedAt: value);
  }

  set note(String? value) {
    state = state.copyWith(note: value);
  }

  set activity(Activity value) {
    state = state.copyWith(activity: value.toEntity);
  }

  set updateLogState(ActivityLogEntity log) {
    state = log;
  }

  void clearState() => state = ActivityLogEntity(
        startedAt: DateTime.now(),
        stoppedAt: DateTime.now(),
      );
}
