class Ticker {
  const Ticker();

  Stream<int> tick({required int ticks}) async* {
    for (int i = ticks; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      yield i - 1;
    }
  }
}
