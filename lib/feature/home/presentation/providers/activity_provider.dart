import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../../../../core/providers/global_providers.dart';
import '../../../../objectbox.g.dart';

part 'generated/activity_provider.g.dart';

@riverpod
class ActivityNotifier extends _$ActivityNotifier {
  late Box<Activity> _box;
  @override
  List<Activity> build() {
    final Store store = ref.watch(objectboxStoreProvider);
    _box = store.box<Activity>();
    _startListener();
    return _box.query().build().find();
  }

  void _startListener() {
    _box
        .query()
        .watch(triggerImmediately: true)
        .map(
          (Query<Activity> query) => query.find(),
        )
        .listen(
      (List<Activity> list) {
        state = list;
      },
    );
  }

  void createActivity(Activity activity) {
    _box.put(activity);
  }
}
