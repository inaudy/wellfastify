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
  const ClockRunning(super.duration, super.elapsed,
      {super.startTimer, super.endTimer});
}

class ClockCompleted extends ClockState {
  const ClockCompleted(super.duration, super.elapsed,
      {DateTime? starTimer, super.endTimer})
      : super(startTimer: starTimer);
}
