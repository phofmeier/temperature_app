part of 'app_settings_bloc.dart';

sealed class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object> get props => [];
}

class AppSettingsOvenTargetTempChanged extends AppSettingsEvent {
  final double ovenTargetTemperature;

  const AppSettingsOvenTargetTempChanged(this.ovenTargetTemperature);
}

class AppSettingsCoreTargetTempChanged extends AppSettingsEvent {
  final double coreTargetTemperature;

  const AppSettingsCoreTargetTempChanged(this.coreTargetTemperature);
}
