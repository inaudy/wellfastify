import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/models/fasting_model.dart';
import 'package:wellfastify/services/db_service.dart';
part 'fasting_event.dart';
part 'fasting_state.dart';

class FastingBloc extends Bloc<FastingEvent, FastingState> {
  final DBService dbService;
  FastingBloc({required this.dbService}) : super(FastingInitial()) {
    on<FastingCreate>(_onCreate);
    on<FastingUpdate>(_onUpdate);
    on<FastingDelete>(_onDelete);
    on<FastingDeleteAll>(_onDeleteAll);
    on<FastingLoadData>(_onLoad);
  }

  void _onCreate(FastingCreate event, Emitter<FastingState> emit) async {
    emit(FastingLoading());
    try {
      await dbService.insertFasting(event.fasting);
      add(FastingLoadData());
      emit(FastingOperationSuccess());
    } catch (e) {
      emit(FastingError('Failed to create fasting entry $e'));
    }
  }

  void _onUpdate(FastingUpdate event, Emitter<FastingState> emit) async {
    emit(FastingLoading());
    try {
      await dbService.deleteFasting(event.id);
      await dbService.insertFasting(event.updatedFasting);
      emit(FastingOperationSuccess());
    } catch (e) {
      emit(FastingError('Failed to update fasting entry $e'));
    }
  }

  void _onDelete(FastingDelete event, Emitter<FastingState> emit) async {
    emit(FastingLoading());
    try {
      await dbService.deleteFasting(event.id);
      emit(FastingOperationSuccess());
    } catch (e) {
      emit(FastingError('Failed to delete fasting entry'));
    }
  }

  void _onDeleteAll(FastingDeleteAll event, Emitter<FastingState> emit) async {
    try {
      await dbService.deleteAllFastings();
      emit(FastingOperationSuccess());
    } catch (e) {
      emit(FastingError('Failed to delete all datta $e'));
    }
  }

  void _onLoad(FastingLoadData event, Emitter<FastingState> emit) async {
    emit(FastingLoading());
    //await dbService.insertRandomFastingData();

    try {
      final totalFasts = await dbService.getTotalFasts();
      final totalFastingTime = await dbService.getTotalFastingTime();
      final averageFast = await dbService.getAverageFast();
      final longestFastTime = await dbService.getLongestFast();
      final maxStreak = await dbService.getMaxStreak();
      final currentStreak = await dbService.getCurrentStreak();
      final List<Fasting> fastingList = await dbService.getFastings();

      emit(FastingCrudLoaded(totalFasts, totalFastingTime, averageFast,
          longestFastTime, maxStreak, currentStreak, fastingList));
    } catch (e) {
      emit(FastingError('error loading data $e'));
    }
  }
}
