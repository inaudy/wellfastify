part of 'clock_bloc.dart';

abstract class ClockState {
  final int duration;
  final DateTime? startTimer;
  final DateTime? endTimer;
  final int elapsed;

  const ClockState(this.duration, this.elapsed,
      {this.startTimer, this.endTimer});
}

class ClockInitial extends ClockState {
  const ClockInitial(int duration) : super(duration, 0);
}

class ClockRunning extends ClockState {
  const ClockRunning(int duration, int elapsed,
      {DateTime? startTimer, DateTime? endTimer})
      : super(duration, elapsed, startTimer: startTimer, endTimer: endTimer);
}

class ClockCompleted extends ClockState {
  const ClockCompleted(int duration, int elapsed,
      {DateTime? starTimer, DateTime? endTimer})
      : super(duration, elapsed, startTimer: starTimer, endTimer: endTimer);
}
