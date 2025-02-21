import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/entities/activity_entities.dart';
import '../../../../core/providers/global_providers.dart';
import '../../../../objectbox.g.dart';

part 'generated/activity_provider.g.dart';

@riverpod
class ActivityNotifier extends _$ActivityNotifier {
  late Box<ActivityEntity> _box;
  @override
  List<ActivityEntity> build() {
    final Store store = ref.watch(objectboxStoreProvider);
    _box = store.box<ActivityEntity>();
    return _box.query().build().find();
  }

  void createActivity(ActivityEntity activity) {
    _box.put(activity);
  }
}
