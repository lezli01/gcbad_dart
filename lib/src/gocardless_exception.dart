class GoCardlessException implements Exception {
  final String message;

  GoCardlessException({required this.message});

  @override
  String toString() => 'GoCardlessException: $message';
}
