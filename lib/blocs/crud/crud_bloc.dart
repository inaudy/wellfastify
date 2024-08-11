import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/models/fasting_model.dart';
import 'package:wellfastify/services/db_service.dart';
part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  final DBService dbService;

  CrudBloc({required this.dbService}) : super(CrudInitial()) {
    on<CreateFasting>(_onCreateFasting);
    on<UpdateFasting>(_onUpdateFasting);
    on<DeleteFasting>(_onDeleteFasting);
    on<DeleteAll>(_onDeleteAll);
    on<LoadFastingData>(_onLoadFastingData);
  }

  void _onCreateFasting(CreateFasting event, Emitter<CrudState> emit) async {
    emit(CrudLoading());
    try {
      await dbService.insertFasting(event.fasting);
      emit(CrudOperationSuccess());
    } catch (e) {
      emit(CrudError('Failed to create fasting entry'));
    }
  }

  void _onUpdateFasting(UpdateFasting event, Emitter<CrudState> emit) async {
    emit(CrudLoading());
    try {
      await dbService.deleteFasting(event.id); // Delete old entry
      await dbService
          .insertFasting(event.updatedFasting); // Insert updated entry
      emit(CrudOperationSuccess());
    } catch (e) {
      emit(CrudError('Failed to update fasting entry'));
    }
  }

  void _onDeleteFasting(DeleteFasting event, Emitter<CrudState> emit) async {
    emit(CrudLoading());
    try {
      await dbService.deleteFasting(event.id);
      emit(CrudOperationSuccess());
    } catch (e) {
      emit(CrudError('Failed to delete fasting entry'));
    }
  }

  void _onDeleteAll(DeleteAll event, Emitter<CrudState> emit) async {
    try {
      await dbService.deleteAllFastings();
      emit(CrudOperationSuccess());
    } catch (e) {
      emit(CrudError('Failed to delete all datta'));
    }
  }

  FutureOr<void> _onLoadFastingData(event, Emitter<CrudState> emit) async {
    emit(CrudLoading());
    try {
      final totalFasts = await dbService.getTotalFasts();
      final totalFastingTime = await dbService.getTotalFastingTime();
      final averageFast = await dbService.getAverageFast();
      final longestFastTime = await dbService.getLongestFast();
      final maxStreak = await dbService.getMaxStreak();
      final currentStreak = await dbService.getCurrentStreak();
      emit(CrudLoaded(totalFasts, totalFastingTime, averageFast,
          longestFastTime, maxStreak, currentStreak));
    } catch (e) {
      emit(CrudError('error loading data $e'));
    }
  }
}
