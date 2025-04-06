import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/models/activity.dart';
import '../../data/models/activity_log.dart';
import '../../data/repositories/activity_logs_repo.dart';

part 'generated/activity_logs_provider.g.dart';

@riverpod
class ActivityLogsNotifier extends _$ActivityLogsNotifier {
  late final ActivityLogRepository _repository;

  @override
  List<ActivityLog> build(DateTime? fromTime, DateTime? toTime) {
    _repository = ref.watch(activityLogRepositoryProvider);

    final Stream<List<ActivityLog>> stream = (fromTime == null)
        ? _repository.watchAll()
        : _repository.watchBetween(
            DateTime(fromTime.year, fromTime.month, fromTime.day),
            DateTime(
              (toTime ?? fromTime).year,
              (toTime ?? fromTime).month,
              toTime?.day ?? fromTime.day + 1,
            ),
          );

    ref.listen<AsyncValue<List<ActivityLog>>>(
      StreamProvider<List<ActivityLog>>((_) => stream),
      (_, AsyncValue<List<ActivityLog>> next) {
        next.whenData((List<ActivityLog> logs) {
          state = logs;
        });
      },
    );

    return fromTime == null
        ? _repository.getAll()
        : _repository.getBetween(
            DateTime(fromTime.year, fromTime.month, fromTime.day),
            DateTime(
              (toTime ?? fromTime).year,
              (toTime ?? fromTime).month,
              toTime?.day ?? fromTime.day + 1,
            ),
          );
  }

  Map<Activity, (Duration, double)> getStats() {
    final Map<Activity, Duration> durations = <Activity, Duration>{};
    Duration total = Duration.zero;

    for (final ActivityLog log in state) {
      durations[log.activity] =
          (durations[log.activity] ?? Duration.zero) + log.duration;
      total += log.duration;
    }

    return durations.map((Activity activity, Duration duration) {
      final double percent =
          total.inSeconds > 0 ? duration.inSeconds / total.inSeconds : 0.0;
      return MapEntry<Activity, (Duration, double)>(
        activity,
        (duration, percent),
      );
    });
  }
}
