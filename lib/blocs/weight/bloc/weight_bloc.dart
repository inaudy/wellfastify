import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/models/weight_model.dart';
import 'package:wellfastify/services/db_service.dart';

part 'weight_event.dart';
part 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  final DBService dbService;
  WeightBloc({required this.dbService}) : super(WeightInitial()) {
    on<WeightCreate>(_onCreate);
    on<WeightDelete>(_onDelete);
    on<WeightDeleteAll>(_onDeleteAll);
    on<WeightLoadData>(_onLoad);
  }
  void _onCreate(WeightCreate event, Emitter<WeightState> emit) async {
    emit(WeightLoading());
    try {
      await dbService.insertWeight(event.weight);
      emit(WeightOperationSuccess());
    } catch (e) {
      emit(WeightError('error loggin the weight $e'));
    }
  }

  void _onDelete(WeightDelete event, Emitter<WeightState> emit) async {
    emit(WeightLoading());
    try {
      await dbService.deleteWeight(event.id);
      emit(WeightOperationSuccess());
    } catch (e) {
      emit(WeightError('Failed to delete fasting entry'));
    }
  }

  void _onDeleteAll(WeightDeleteAll event, Emitter<WeightState> emit) async {
    try {
      await dbService.deleteAllWeights();
      emit(WeightOperationSuccess());
    } catch (e) {
      emit(WeightError('Failed to delete all data $e'));
    }
  }

  void _onLoad(WeightLoadData event, Emitter<WeightState> emit) async {
    emit(WeightLoading());
    try {
      final weights = await dbService.getLastWeights();
      final lastWeightEntry = weights.last;
      final lastweight = lastWeightEntry['weight'] as double;
      final lastdate = DateTime.parse(lastWeightEntry['date'] as String);
      emit(WeightLoaded(lastweight, lastdate, weights));
    } catch (e) {
      emit(WeightError('error loading $e'));
    }
  }
}