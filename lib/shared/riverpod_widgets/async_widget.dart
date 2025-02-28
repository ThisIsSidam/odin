import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    required this.value,
    required Widget Function(T) this.data,
    this.loading,
    this.error,
    super.key,
  }) : orElse = null;

  const AsyncValueWidget.orElse({
    required this.value,
    required Widget Function() this.orElse,
    this.data,
    this.loading,
    this.error,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T)? data;
  final Widget Function()? loading;
  final Widget Function(Object, StackTrace?)? error;
  final Widget Function()? orElse;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: getData(),
      loading: getLoading(),
      error: getError(),
    );
  }

  Widget Function(T) getData() {
    return data ?? (_) => orElse!.call();
  }

  Widget Function() getLoading() {
    return loading ?? orElse ?? CircularProgressIndicator.new;
  }

  Widget Function(Object, StackTrace?) getError() {
    return error ?? (_, __) => orElse!.call();
  }
}
