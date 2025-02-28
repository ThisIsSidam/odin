import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StateSelector<P, S> extends ConsumerWidget {
  const StateSelector({
    required this.provider,
    required this.selector,
    required this.builder,
    super.key,
  });

  final ProviderBase<P> provider;
  final S Function(P) selector;
  final Widget Function(BuildContext, S) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final S value = ref.watch(provider.select(selector));
    return builder(context, value);
  }
}
