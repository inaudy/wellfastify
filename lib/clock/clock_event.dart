part of 'clock_bloc.dart';

sealed class ClockEvent {
  const ClockEvent();
}

final class StartedClockInitial extends ClockEvent {
  const StartedClockInitial();
}

final class StartedFromPref extends ClockEvent {
  const StartedFromPref(this.duration, {required this.elapsed});
  final int elapsed;
  final int duration;
}

final class StartedClock extends ClockEvent {
  const StartedClock(this.duration, {required this.elapsed});
  final int elapsed;
  final int duration;
}

final class SetClock extends ClockEvent {
  const SetClock({required this.duration, required this.elapsed});
  final int duration;
  final int elapsed;
}

final class ResetClock extends ClockEvent {
  const ResetClock({required this.duration});
  final int duration;
}

final class CompletedClock extends ClockEvent {
  const CompletedClock({required this.duration, required this.elapsed});
  final int duration;
  final int elapsed;
}

final class TickedClock extends ClockEvent {
  final int duration;
  final int elapsed;
  const TickedClock({required this.elapsed, required this.duration});
}
