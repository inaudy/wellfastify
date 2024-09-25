part of 'clock_bloc.dart';

abstract class ClockEvent {
  const ClockEvent();
}

class SetClock extends ClockEvent {
  final int duration;
  final int elapsed;

  const SetClock(this.elapsed, {required this.duration});
}

class StartedFromPref extends ClockEvent {
  final int duration;
  final int elapsed;

  const StartedFromPref(this.duration, {required this.elapsed});
}

class ChangeDuration extends ClockEvent {
  final int duration;
  final int elapsed;
  const ChangeDuration(this.duration, this.elapsed);
}

class StartedClock extends ClockEvent {
  final int duration;
  final int elapsed;
  const StartedClock(this.duration, {required this.elapsed});
}

class ResetClock extends ClockEvent {
  final int duration;

  const ResetClock(this.duration);
}

class CompletedClock extends ClockEvent {
  final int duration;
  final int elapsed;

  const CompletedClock(this.duration, {required this.elapsed});
}

class TickedClock extends ClockEvent {
  final int duration;
  final int elapsed;

  const TickedClock({required this.duration, required this.elapsed});
}
