part of 'weight_bloc.dart';

sealed class WeightEvent {}

class WeightCreate extends WeightEvent {
  final Weight weight;
  WeightCreate(this.weight);
}

class WeightDelete extends WeightEvent {
  final int id;
  WeightDelete(this.id);
}

class WeightDeleteAll extends WeightEvent {
  WeightDeleteAll();
}

class WeightLoadData extends WeightEvent {}
