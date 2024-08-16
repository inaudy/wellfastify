part of 'fasting_bloc.dart';

sealed class FastingState {}

final class FastingInitial extends FastingState {}

class FastingLoading extends FastingState {}

class FastingCrudLoaded extends FastingState {
  final int totalFasts;
  final int totalFastingTime;
  final int averageFast;
  final int longestFastTime;
  final int maxStreak;
  final int currentStreak;
  final List<Map<String, dynamic>> fastingTimes;
  FastingCrudLoaded(
      this.totalFasts,
      this.totalFastingTime,
      this.averageFast,
      this.longestFastTime,
      this.maxStreak,
      this.currentStreak,
      this.fastingTimes);
}

class FastingOperationSuccess extends FastingState {}

class FastingError extends FastingState {
  final String message;
  FastingError(this.message);
}
