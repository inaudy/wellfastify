import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/models/ticker.dart';
import 'package:wellfastify/models/timer_model.dart';
import 'package:wellfastify/services/db_service.dart';
part 'clock_event.dart';
part 'clock_state.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState>
    with WidgetsBindingObserver {
  final Ticker _ticker;
  final DBService _dbService;
  static const int _duration = 16 * 60 * 60; // 16:8 FASTING
  int _elapsed = 0;
  DateTime? _startTimer;
  DateTime? _endTimer;
  StreamSubscription<int>? _tickerSubscription;

  ClockBloc({
    required Ticker ticker,
    required DBService dbService,
  })  : _ticker = ticker,
        _dbService = dbService,
        super(const ClockInitial(_duration)) {
    WidgetsBinding.instance.addObserver(this);
    on<SetClock>(_setClock);
    on<ChangeDuration>(_onChangeDuration);
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

  void _init() async {
    TimerData? savedTimer = await _dbService.getTimer();
    if (savedTimer != null) {
      final now = DateTime.now();
      final elapsed = now.difference(savedTimer.startTime).inSeconds;
      _startTimer = savedTimer.startTime;
      add(StartedFromPref(savedTimer.duration, elapsed: elapsed));
    }
  }

  void _onStartFromPref(StartedFromPref event, Emitter<ClockState> emit) {
    _elapsed = event.elapsed;
    _endTimer = _startTimer!.add(Duration(seconds: event.duration));
    emit(ClockRunning(event.duration, event.elapsed,
        startTimer: _startTimer, endTimer: _endTimer));
    _startTicker(event.duration, event.elapsed);
  }

  void _onStarted(StartedClock event, Emitter<ClockState> emit) async {
    await _dbService.deleteTimerData();
    _startTimer = DateTime.now();
    _endTimer = _startTimer!.add(Duration(seconds: event.duration));
    TimerData newTimer = TimerData(
      startTime: _startTimer!,
      duration: event.duration,
    );
    await _dbService.insertTimer(newTimer);
    _elapsed = event.elapsed;
    emit(ClockRunning(event.duration, event.elapsed,
        startTimer: _startTimer, endTimer: _endTimer));
    _startTicker(event.duration, event.elapsed);
  }

  void _onChangeDuration(ChangeDuration event, Emitter<ClockState> emit) async {
    await _dbService.updateTimerData(newDuration: event.duration);
    _endTimer = _startTimer!.add(Duration(seconds: event.duration));
    _elapsed = event.elapsed;
    emit(ClockRunning(event.duration, event.elapsed,
        startTimer: _startTimer, endTimer: _endTimer));
    _startTicker(event.duration, event.elapsed);
  }

  void _onReset(ResetClock event, Emitter<ClockState> emit) async {
    await _dbService.deleteTimerData();
    _tickerSubscription?.cancel();
    _startTimer = null;
    _endTimer = null;
    emit(ClockInitial(event.duration));
  }

  void _onCompleted(CompletedClock event, Emitter<ClockState> emit) {
    emit(ClockCompleted(event.duration, event.elapsed,
        starTimer: _startTimer, endTimer: _endTimer));
  }

  void _onTicked(TickedClock event, Emitter<ClockState> emit) {
    _elapsed++;
    emit(_elapsed < event.duration
        ? ClockRunning(event.duration, _elapsed,
            startTimer: _startTimer, endTimer: _endTimer)
        : ClockCompleted(event.duration, _elapsed,
            starTimer: _startTimer, endTimer: _endTimer));
  }

  void _setClock(SetClock event, Emitter<ClockState> emit) {
    emit(ClockInitial(event.duration));
  }

  void _startTicker(int duration, int elapsed) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick()
        .listen((_) => add(TickedClock(elapsed: _elapsed, duration: duration)));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _init();
    }
  }
}
