import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  CrudBloc() : super(CrudInitial()) {
    on<CrudEvent>((event, emit) {});
  }
}
