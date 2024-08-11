// crud_state.dart
part of 'crud_bloc.dart';

abstract class CrudState {}

class CrudInitial extends CrudState {}

class CrudLoading extends CrudState {}

class CrudLoaded extends CrudState {
  final int totalFasts;
  final int totalFastingTime;
  final int averageFast;
  final int longestFastTime;
  final int maxStreak;
  final int currentStreak;
  CrudLoaded(this.totalFasts, this.totalFastingTime, this.averageFast,
      this.longestFastTime, this.maxStreak, this.currentStreak);
}

class CrudOperationSuccess extends CrudState {}

class CrudError extends CrudState {
  final String message;
  CrudError(this.message);
}
