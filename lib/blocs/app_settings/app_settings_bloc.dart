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
    on<AppSettingsUserCoreTargetTempChanged>((event, emit) {
      var newState = state.copyWith(
          status: AppSettingsStatus.notSynchronized,
          coreTargetTemperature: event.coreTargetTemperature);
      temperatureServerRepository.setSettings(newState);
      emit(newState);
    });
    on<AppSettingsUserOvenTargetTempChanged>((event, emit) {
      var newState = state.copyWith(
          status: AppSettingsStatus.notSynchronized,
          ovenTargetTemperature: event.ovenTargetTemperature);
      temperatureServerRepository.setSettings(newState);
      emit(newState);
    });
    on<AppSettingsServerSettingChanged>((event, emit) {
      emit(state.copyWith(
          status: AppSettingsStatus.synchronized,
          ovenTargetTemperature: event.ovenTargetTemperature,
          coreTargetTemperature: event.coreTargetTemperature));
    });
    on<AppSettingsServerConnectedEvent>((event, emit) {
      temperatureServerRepository.triggerGetSettings();
      emit(state.copyWith(status: AppSettingsStatus.notSynchronized));
    });
    on<AppSettingsServerNotConnectedEvent>((event, emit) {
      emit(state.copyWith(status: AppSettingsStatus.notConnected));
    });
  }
}
