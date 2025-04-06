import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/models/activity.dart';
import '../../data/models/activity_log.dart';

part 'generated/log_fields_provider.g.dart';

@Riverpod(keepAlive: true)
class LogFieldsNotifier extends _$LogFieldsNotifier {
  @override
  ActivityLog build() {
    return ActivityLog.isNull();
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
    state = state.copyWith(activity: value);
  }

  set updateLogState(ActivityLog log) {
    state = log;
  }

  void clearState() => state = ActivityLog.isNull();
}
