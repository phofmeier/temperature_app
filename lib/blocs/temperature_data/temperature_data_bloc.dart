import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:temperature_app/repository/temperature_server_repository.dart';

part 'temperature_data_event.dart';
part 'temperature_data_state.dart';

class TemperatureDataBloc
    extends Bloc<TemperatureDataEvent, TemperatureDataState> {
  TemperatureServerRepository temperatureServerRepository;

  TemperatureDataBloc({required this.temperatureServerRepository})
      : super(const TemperatureDataInitial()) {
    temperatureServerRepository.newTemperatureDataReceived.listen((event) {
      add(event);
    });
    on<NewTemperatureDataReceived>((event, emit) {
      emit(TemperatureDataState(
        event.currentCoreTemp,
        event.currentOvenTemp,
        event.currentCoreChange,
        event.currentOvenChange,
      ));
    });
  }
}
