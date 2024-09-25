import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/services/db_service.dart';
part 'weightgoal_event.dart';
part 'weightgoal_state.dart';

class WeightGoalBloc extends Bloc<WeightGoalEvent, WeightGoalState> {
  final DBService dbService;
  WeightGoalBloc({required this.dbService}) : super(WeightGoalInitial()) {
    on<WeightGoalLoadData>(_onLoad);
    on<WeightGoalUpdate>(_onUpdate);
  }

  void _onUpdate(WeightGoalUpdate event, Emitter<WeightGoalState> emit) async {
    try {
      await dbService.updateWeightGoal(event.goal);
      add(WeightGoalLoadData());
    } catch (e) {
      emit(WeightGoalError('error updating weight goal $e'));
    }
  }

  void _onLoad(WeightGoalLoadData event, Emitter<WeightGoalState> emit) async {
    try {
      double? currentGoal = await dbService.getWeightGoal();
      if (currentGoal != null) {
        emit(WeightGoalLoaded(currentGoal));
      } else {
        emit(WeightGoalLoaded(0)); // Default value if not set
      }
    } catch (e) {
      emit(WeightGoalError('error loading weight goal $e'));
    }
  }
}
