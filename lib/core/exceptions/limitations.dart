interface class Limitation implements Exception {
  const Limitation({required this.message});

  final String message;
}

class LiveActivityLimitation implements Limitation {
  @override
  final String message;

  LiveActivityLimitation()
      : message = 'Live activity limit reached. Cannot start more activities.';
}

class MultiTaskingNotAllowedLimitation implements Limitation {
  @override
  final String message;

  MultiTaskingNotAllowedLimitation() : message = 'Multi-tasking is not allowed';
}

class NameRequiredLimitation implements Limitation {
  @override
  final String message;

  NameRequiredLimitation() : message = 'Give name to the activity';
}
