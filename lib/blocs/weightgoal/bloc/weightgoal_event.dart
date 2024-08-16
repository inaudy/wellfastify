part of 'weightgoal_bloc.dart';

sealed class WeightGoalEvent {}

class WeightGoalUpdate extends WeightGoalEvent {
  double goal;
  WeightGoalUpdate({required this.goal});
}

class WeightGoalLoadData extends WeightGoalEvent {}
