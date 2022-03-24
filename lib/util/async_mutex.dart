import 'dart:async';

/// flutter synchronize，
/// Forming a linked table with future
/// The sqlite database requires the use of

class AsyncMutex {


  Future _next = new Future.value(null);

  /// Request [operation] to be run exclusively.
  ///
  /// Waits for all previously requested operations to complete,
  /// then runs the operation and completes the returned future with the
  /// result.
  Future<T> run<T>(Future<T> operation()) {
    var completer = new Completer<T>();
    _next.whenComplete(() {
      completer.complete(new Future<T>.sync(operation));
    });
    return _next = completer.future;
  }
}
