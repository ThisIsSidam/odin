import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/global_providers.g.dart';

@riverpod
Store objectboxStore(Ref ref) {
  throw UnimplementedError('Objectbox store has not been created yet!');
}
