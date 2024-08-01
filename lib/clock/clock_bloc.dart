import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellfastify/models/ticker.dart';
part 'clock_event.dart';
part 'clock_state.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState>
    with WidgetsBindingObserver {
  final SharedPreferences _sharedPreferences;
  final Ticker _ticker;
  static const int _duration = 24 * 60 * 60; // 18:6 FASTING
  int _elapsed = 0;
  StreamSubscription<int>? _tickerSubscription;

  ClockBloc({
    required Ticker ticker,
    required SharedPreferences sharedPreferences,
  })  : _ticker = ticker,
        _sharedPreferences = sharedPreferences,
        super(const ClockInitial(_duration, 0)) {
    WidgetsBinding.instance.addObserver(this);
    on<SetClock>(_setClock);
    on<StartedFromPref>(_onStartFromPref);
    on<StartedClock>(_onStarted);
    on<ResetClock>(_onReset);
    on<CompletedClock>(_onCompleted);
    on<TickedClock>(_onTicked);

    _init();
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);
    await _tickerSubscription?.cancel();
    return super.close();
  }

  void _init() {
    final nowEpoch = DateTime.now().millisecondsSinceEpoch;
    final startedEpoch = _sharedPreferences.getInt('saved_datetime') ?? 0;
    final duration = _sharedPreferences.getInt('duration') ?? 0;

    if (startedEpoch != 0) {
      final now = DateTime.fromMillisecondsSinceEpoch(nowEpoch);
      final started = DateTime.fromMillisecondsSinceEpoch(startedEpoch);
      final elapsed = now.difference(started).inSeconds;
      add(StartedFromPref(duration, elapsed: elapsed));
    }
  }

  void _onStartFromPref(StartedFromPref event, Emitter<ClockState> emit) {
    _elapsed = event.elapsed;
    emit(ClockRunning(event.duration, event.elapsed));
    _startTicker(event.duration, event.elapsed);
  }

  void _onStarted(StartedClock event, Emitter<ClockState> emit) {
    _sharedPreferences.setInt(
        'saved_datetime', DateTime.now().millisecondsSinceEpoch);
    _sharedPreferences.setInt('duration', event.duration);
    _elapsed = event.elapsed;
    emit(ClockRunning(event.duration, event.elapsed));
    _startTicker(event.duration, event.elapsed);
  }

  void _onReset(ResetClock event, Emitter<ClockState> emit) {
    _sharedPreferences.remove('saved_datetime');
    _sharedPreferences.remove('duration');
    _tickerSubscription?.cancel();
    emit(ClockInitial(event.duration, 0));
  }

  void _onCompleted(CompletedClock event, Emitter<ClockState> emit) {
    emit(ClockCompleted(event.duration, event.elapsed));
  }

  void _onTicked(TickedClock event, Emitter<ClockState> emit) {
    _elapsed++;
    emit(_elapsed < event.duration
        ? ClockRunning(event.duration, _elapsed)
        : ClockCompleted(event.duration, _elapsed));
  }

  void _setClock(SetClock event, Emitter<ClockState> emit) {
    emit(ClockInitial(event.duration, event.elapsed));
  }

  void _startTicker(int duration, int elapsed) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: duration - elapsed).listen(
        (duration) => add(TickedClock(elapsed: _elapsed, duration: duration)));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _init();
    }
  }
}
