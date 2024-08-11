// crud_event.dart
part of 'crud_bloc.dart';

abstract class CrudEvent {}

class CreateFasting extends CrudEvent {
  final Fasting fasting;
  CreateFasting(this.fasting);
}

class UpdateFasting extends CrudEvent {
  final int id;
  final Fasting updatedFasting;
  UpdateFasting(this.id, this.updatedFasting);
}

class DeleteFasting extends CrudEvent {
  final int id;
  DeleteFasting(this.id);
}

class DeleteAll extends CrudEvent {
  DeleteAll();
}

class LoadFastingData extends CrudEvent {}
