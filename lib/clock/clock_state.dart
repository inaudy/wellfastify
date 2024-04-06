// ignore_for_file: prefer_final_fields, unused_field, overridden_fields, annotate_overrides

part of 'clock_bloc.dart';

sealed class ClockState {
  const ClockState(this.duration, this.elapsed);
  final int duration;
  final int elapsed;
}

final class ClockInitial extends ClockState {
  const ClockInitial(this.duration, this.elapsed) : super(duration, elapsed);
  final int duration;
  final int elapsed;
}

final class ClockSet extends ClockState {
  const ClockSet(this.duration, this.elapsed) : super(duration, elapsed);
  final int duration;
  final int elapsed;
}

final class ClockRunning extends ClockState {
  const ClockRunning(this.duration, this.elapsed) : super(duration, elapsed);
  final int duration;
  final int elapsed;
}

final class ClockReset extends ClockState {
  const ClockReset(this.duration) : super(duration, 0);
  final int duration;
}

final class ClockCompleted extends ClockState {
  const ClockCompleted(this.duration, this.elapsed) : super(duration, elapsed);
  final int duration;
  final int elapsed;
}
