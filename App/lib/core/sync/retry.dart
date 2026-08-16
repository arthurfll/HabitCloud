/// The nightly backup job runs from a cold start (Android may have killed the app process
/// entirely before waking it in the background), so the very first network attempt can fail
/// before connectivity/DNS is fully up. Retries every 10s, up to 10 attempts, before giving up —
/// the sync simply gets picked up on the next scheduled run if all attempts fail.
Future<T?> withColdStartRetry<T>(
  Future<T> Function() action, {
  int maxAttempts = 10,
  Duration delay = const Duration(seconds: 10),
  void Function(int attempt, Object error)? onAttemptFailed,
}) async {
  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await action();
    } catch (error) {
      onAttemptFailed?.call(attempt, error);
      if (attempt == maxAttempts) return null;
      await Future.delayed(delay);
    }
  }
  return null;
}
