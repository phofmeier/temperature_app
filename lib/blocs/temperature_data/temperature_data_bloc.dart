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
    on<TemperatureDataEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
