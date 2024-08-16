part of 'fasting_bloc.dart';

sealed class FastingEvent {}

class FastingCreate extends FastingEvent {
  final Fasting fasting;
  FastingCreate(this.fasting);
}

class FastingUpdate extends FastingEvent {
  final int id;
  final Fasting updatedFasting;
  FastingUpdate(this.id, this.updatedFasting);
}

class FastingDelete extends FastingEvent {
  final int id;
  FastingDelete(this.id);
}

class FastingDeleteAll extends FastingEvent {
  FastingDeleteAll();
}

class FastingLoadData extends FastingEvent {}
