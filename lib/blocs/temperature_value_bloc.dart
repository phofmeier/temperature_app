import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TemperatureValueEvent {}

class TemperatureValueChanged extends TemperatureValueEvent {}

class TemperatureValueState {
  double value;

  double change;

  TemperatureValueState({required this.value, required this.change});
  TemperatureValueState add(double val) {
    value = value + val;
    return TemperatureValueState(value: value, change: change);
  }
}

class TemperatureValueBloc
    extends Bloc<TemperatureValueEvent, TemperatureValueState> {
  TemperatureValueBloc()
      : super(TemperatureValueState(value: 2.0, change: 0.7)) {
    on<TemperatureValueChanged>((event, emit) {
      emit(state.add(1.0));
    });
  }
}
