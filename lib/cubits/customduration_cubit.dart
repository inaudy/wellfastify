import 'package:flutter_bloc/flutter_bloc.dart';

class CustomdurationCubit extends Cubit<int> {
  CustomdurationCubit() : super(1);

  void updateDuration(int duration) {
    emit(duration);
  }
}
