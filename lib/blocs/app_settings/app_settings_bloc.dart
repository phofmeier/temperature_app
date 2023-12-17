import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/repository/temperature_server_repository.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final TemperatureServerRepository temperatureServerRepository;

  AppSettingsBloc({required this.temperatureServerRepository})
      : super(const AppSettingsInitial()) {
    temperatureServerRepository.status.listen((event) {
      print("AppSettingsBloc:  ${event.state}");
      if (event.state == TemperatureServerConnectionState.connected) {
        add(AppSettingsServerConnectedEvent());
      } else {
        add(AppSettingsServerNotConnectedEvent());
      }
    });
    // todo add sync to server
    on<AppSettingsUserCoreTargetTempChanged>((event, emit) {
      emit(AppSettingsState(
          status: AppSettingsStatus.notSynchronized,
          ovenTargetTemperature: state.ovenTargetTemperature,
          coreTargetTemperature: event.coreTargetTemperature));
    });
    on<AppSettingsUserOvenTargetTempChanged>((event, emit) {
      // Todo add sync to server
      emit(AppSettingsState(
          status: AppSettingsStatus.notSynchronized,
          ovenTargetTemperature: event.ovenTargetTemperature,
          coreTargetTemperature: state.coreTargetTemperature));
    });
    on<AppSettingsServerConnectedEvent>((event, emit) {
      temperatureServerRepository.getSettings();
      emit(AppSettingsState(
          status: AppSettingsStatus.notSynchronized,
          ovenTargetTemperature: state.ovenTargetTemperature,
          coreTargetTemperature: state.coreTargetTemperature));
    });
    on<AppSettingsServerNotConnectedEvent>((event, emit) {
      emit(AppSettingsState(
          status: AppSettingsStatus.notConnected,
          ovenTargetTemperature: state.ovenTargetTemperature,
          coreTargetTemperature: state.coreTargetTemperature));
    });
  }
}
