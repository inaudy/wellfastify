import 'package:flutter_bloc/flutter_bloc.dart';

class CustomdurationCubit extends Cubit<int> {
  CustomdurationCubit() : super(16);

  void updateDuration(int duration) {
    emit(duration);
  }
}
