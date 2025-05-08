import 'package:objectbox/objectbox.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/exceptions/limitations.dart';
import '../../../../core/providers/global_providers.dart';
import '../../data/entity/task_entity.dart';
import '../../data/models/task.dart';

part 'generated/tasks_provider.g.dart';

@riverpod
class TasksNotifier extends _$TasksNotifier {
  late Box<TaskEntity> _box;
  @override
  List<Task> build() {
    final Store store = ref.watch(objectboxStoreProvider);
    _box = store.box<TaskEntity>();
    _startListener();
    return _box.getAll().map((TaskEntity entity) => entity.toModel).toList();
  }

  void _startListener() {
    _box
        .query()
        .watch(triggerImmediately: true)
        .map(
          (Query<TaskEntity> query) => query.find(),
        )
        .listen(
      (List<TaskEntity> list) {
        state = list.map((TaskEntity entity) => entity.toModel).toList();
      },
    );
  }

  void createActivity(TaskEntity activity) {
    if (activity.title == '') throw NameRequiredLimitation();
    _box.put(activity);
  }

  Task? getActivity(int id) {
    return _box.get(id)?.toModel;
  }

  void removeActivity(int id) => _box.remove(id);
}
