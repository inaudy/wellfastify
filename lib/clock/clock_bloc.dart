// ignore_for_file: prefer_final_fields

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
  static int _duration = 18 * 60 * 60; //18:6 FASTING
  static int _elapsed = 0;
  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);
    _tickerSubscription?.cancel();
    return super.close();
  }

  ClockBloc(
      {required Ticker ticker, required SharedPreferences sharedPreferences})
      : _ticker = ticker,
        _sharedPreferences = sharedPreferences,
        super(ClockInitial(_duration, 0)) {
    on<SetClock>(_setClock);
    on<StartedFromPref>(_onStartFromPref);
    on<StartedClock>(_onStarted);
    on<ResetClock>(_onReset);
    on<CompletedClock>(_onCompleted);
    on<TickedClock>(_onTicked);

    //on init clock check for savedpreferences running
    _init();
  }

  void _init() {
    //emit(ClockInitial(14 * 60 * 60, 13 * 60 * 60));
    //on init clock check for savedpreferences running
    //check if there is any saved then run _onStartFromPref

    int nowEpoch = DateTime.now().millisecondsSinceEpoch;
    int startedEpoch = _sharedPreferences.getInt('saved_datetime') ?? 0;
    int duration = _sharedPreferences.getInt('duration') ?? 0;

    if (startedEpoch != 0) {
      DateTime now = DateTime.fromMillisecondsSinceEpoch(nowEpoch);
      DateTime started = DateTime.fromMillisecondsSinceEpoch(startedEpoch);
      int elapsed = now.difference(started).inSeconds;
      add(StartedFromPref(duration, elapsed: elapsed));
    }

    //add(const StartedClock(60, elapsed: 55));
    //or
  }

  void _onStartFromPref(StartedFromPref event, Emitter<ClockState> emit) {
    _elapsed = event.elapsed; //aqui
    emit(ClockRunning(event.duration, event.elapsed));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: event.duration).listen(
        (duration) =>
            add(TickedClock(elapsed: event.elapsed, duration: event.duration)));
  }

  void _onStarted(StartedClock event, Emitter<ClockState> emit) {
    _sharedPreferences.setInt(
        'saved_datetime', DateTime.now().millisecondsSinceEpoch);
    _sharedPreferences.setInt('duration', event.duration);
    _elapsed = event.elapsed; //aqui
    emit(ClockRunning(event.duration, event.elapsed));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: event.duration).listen(
        (duration) =>
            add(TickedClock(elapsed: event.elapsed, duration: event.duration)));
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
    //emit(ClockRunning(event.duration, _elapsed));
    emit(_elapsed < event.duration
        ? ClockRunning(event.duration, _elapsed)
        : ClockCompleted(event.duration, _elapsed));
  }

  void _setClock(SetClock event, Emitter<ClockState> emit) {
    emit(ClockInitial(event.duration, event.elapsed));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _init();
    }
  }
}
