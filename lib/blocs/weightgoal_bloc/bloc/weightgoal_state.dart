part of 'weightgoal_bloc.dart';

sealed class WeightGoalState {}

final class WeightGoalInitial extends WeightGoalState {}

class WeightGoalLoading extends WeightGoalState {}

final class WeightGoalLoaded extends WeightGoalState {
  final double goal;

  WeightGoalLoaded(this.goal);
}

class WeightGoalOperationSuccess extends WeightGoalState {}

class WeightGoalError extends WeightGoalState {
  final String message;
  WeightGoalError(this.message);
}
