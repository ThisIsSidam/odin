import 'package:flutter/material.dart';

class EnhFutureBuilder<T> extends StatelessWidget {
  const EnhFutureBuilder({
    required this.future,
    required Widget Function(T) this.data,
    this.loading,
    this.error,
    super.key,
  }) : orElse = null;

  const EnhFutureBuilder.orElse({
    required this.future,
    required Widget Function() this.orElse,
    this.data,
    this.loading,
    this.error,
    super.key,
  });

  final Future<T> future;
  final Widget Function(T)? data;
  final Widget Function()? loading;
  final Widget Function(Object, StackTrace?)? error;
  final Widget Function()? orElse;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return error?.call(snapshot.error!, snapshot.stackTrace) ??
              orElse?.call() ??
              Text('Error: ${snapshot.error}');
        }

        if (snapshot.hasData) {
          return data?.call(snapshot.data as T) ??
              orElse?.call() ??
              const SizedBox.shrink();
        }

        return loading?.call() ??
            orElse?.call() ??
            const CircularProgressIndicator();
      },
    );
  }
}
