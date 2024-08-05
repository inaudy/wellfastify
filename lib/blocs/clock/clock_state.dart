part of 'clock_bloc.dart';

abstract class ClockState {
  final int duration;
  final int elapsed;

  const ClockState(this.duration, this.elapsed);
}

class ClockInitial extends ClockState {
  const ClockInitial(int duration) : super(duration, 0);
}

class ClockRunning extends ClockState {
  const ClockRunning(int duration, int elapsed) : super(duration, elapsed);
}

class ClockCompleted extends ClockState {
  const ClockCompleted(int duration, int elapsed) : super(duration, elapsed);
}
