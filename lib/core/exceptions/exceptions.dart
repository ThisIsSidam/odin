interface class Failure implements Exception {
  final String message;
  final StackTrace stackTrace;

  Failure({
    required this.message,
    this.stackTrace = StackTrace.empty,
  });
}

class UnknownException implements Failure {
  @override
  final String message;

  @override
  final StackTrace stackTrace;

  UnknownException({this.stackTrace = StackTrace.empty})
      : message = 'Something went wrong';
}
