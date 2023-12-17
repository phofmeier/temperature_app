import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/repository/temperature_server_repository.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  final TemperatureServerRepository temperatureServerRepository;

  AppSettingsBloc({required this.temperatureServerRepository})
      : super(const AppSettingsInitial()) {
    if (temperatureServerRepository.isConnected()) {
      add(AppSettingsServerConnectedEvent());
    }
    temperatureServerRepository.appSettingsServerSetting.listen((event) {
      add(event);
    });
    temperatureServerRepository.status.listen((event) {
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
    on<AppSettingsServerSettingChanged>((event, emit) {
      emit(AppSettingsState(
          status: AppSettingsStatus.synchronized,
          ovenTargetTemperature: event.ovenTargetTemperature,
          coreTargetTemperature: event.coreTargetTemperature));
    });
    on<AppSettingsServerConnectedEvent>((event, emit) {
      temperatureServerRepository.triggerGetSettings();
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
