import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/entities/activity_entity.dart';
import '../../../../core/data/models/activity.dart';
import '../../../../core/exceptions/limitations.dart';
import '../../../../core/providers/global_providers.dart';
import '../../../../objectbox.g.dart';

part 'generated/activity_provider.g.dart';

@riverpod
class ActivityNotifier extends _$ActivityNotifier {
  late Box<ActivityEntity> _box;
  @override
  List<Activity> build() {
    final Store store = ref.watch(objectboxStoreProvider);
    _box = store.box<ActivityEntity>();
    _startListener();
    return _box
        .getAll()
        .map((ActivityEntity entity) => entity.toModel)
        .toList();
  }

  void _startListener() {
    _box
        .query()
        .watch(triggerImmediately: true)
        .map(
          (Query<ActivityEntity> query) => query.find(),
        )
        .listen(
      (List<ActivityEntity> list) {
        state = list.map((ActivityEntity entity) => entity.toModel).toList();
      },
    );
  }

  void createActivity(ActivityEntity activity) {
    if (activity.name == '') throw NameRequiredLimitation();
    _box.put(activity);
  }

  Activity? getActivity(int id) {
    return _box.get(id)?.toModel;
  }

  void hideActivity(int id) {
    final ActivityEntity? entity = _box.get(id);
    if (entity == null) return;
    entity.hidden = true;
    _box.put(entity);
  }
}
