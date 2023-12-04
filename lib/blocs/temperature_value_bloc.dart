import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/repository/temperature_server_repository.dart';

abstract class TemperatureValueEvent {}

class TemperatureValueChanged extends TemperatureValueEvent {
  // ignore: prefer_typing_uninitialized_variables
  var data;

  TemperatureValueChanged(this.data);
}

class TemperatureValueState extends Equatable {
  final double value;

  final double change;

  const TemperatureValueState({required this.value, required this.change});

  @override
  List<Object?> get props => [value, change];
}

class TemperatureValueBloc
    extends Bloc<TemperatureValueEvent, TemperatureValueState> {
  final TemperatureServerRepository temperatureServerRepository;
  TemperatureValueBloc({required this.temperatureServerRepository})
      : super(const TemperatureValueState(value: 2.0, change: 0.7)) {
    temperatureServerRepository.newTempData
        .listen((event) => add(TemperatureValueChanged(event)));
    on<TemperatureValueChanged>((event, emit) {
      emit(TemperatureValueState(
          value: event.data[0][1], change: event.data[1][1]));
    });
  }
}
