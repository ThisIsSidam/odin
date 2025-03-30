import 'dart:math';

extension ListX<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final T element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  T? get pickRandom {
    if (isEmpty) return null;
    return this[Random().nextInt(length)];
  }
}
