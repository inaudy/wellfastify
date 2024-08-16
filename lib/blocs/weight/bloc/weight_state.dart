part of 'weight_bloc.dart';

sealed class WeightState {}

final class WeightInitial extends WeightState {}

class WeightLoading extends WeightState {}

final class WeightLoaded extends WeightState {
  final double lastWeight;
  final DateTime lastDate;
  final List<Map<String, dynamic>> weights;
  WeightLoaded(this.lastWeight, this.lastDate, this.weights);
}

class WeightOperationSuccess extends WeightState {}

class WeightError extends WeightState {
  final String message;
  WeightError(this.message);
}
