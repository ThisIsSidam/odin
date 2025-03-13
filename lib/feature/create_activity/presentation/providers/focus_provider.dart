import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/focus_provider.g.dart';

enum ActivityFocusedWidget {
  none,
  colorPicker,
  iconPicker,
}

@riverpod
class FocusedWidgetNotifier extends _$FocusedWidgetNotifier {
  @override
  ActivityFocusedWidget build() {
    return ActivityFocusedWidget.none;
  }

  set changeFocus(ActivityFocusedWidget focused) {
    state = focused;
  }
}
