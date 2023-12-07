import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc() : super(const AppSettingsInitial()) {
    on<AppSettingsCoreTargetTempChanged>((event, emit) {
      emit(AppSettingsState(
          ovenTargetTemperature: state.ovenTargetTemperature,
          coreTargetTemperature: event.coreTargetTemperature));
    });
    on<AppSettingsOvenTargetTempChanged>((event, emit) {
      emit(AppSettingsState(
          ovenTargetTemperature: event.ovenTargetTemperature,
          coreTargetTemperature: state.coreTargetTemperature));
    });
  }
}
