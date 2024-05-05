part of 'app_settings_bloc.dart';

sealed class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object> get props => [];
}

class AppSettingsUserOvenTargetTempChanged extends AppSettingsEvent {
  final double ovenTargetTemperature;

  const AppSettingsUserOvenTargetTempChanged(this.ovenTargetTemperature);
  @override
  List<Object> get props => [ovenTargetTemperature];
}

class AppSettingsUserCoreTargetTempChanged extends AppSettingsEvent {
  final double coreTargetTemperature;

  const AppSettingsUserCoreTargetTempChanged(this.coreTargetTemperature);

  @override
  List<Object> get props => [coreTargetTemperature];
}

class AppSettingsUserStartTimeChanged extends AppSettingsEvent {
  final DateTime startTime;

  const AppSettingsUserStartTimeChanged(this.startTime);

  @override
  List<Object> get props => [startTime];
}

class AppSettingsServerSettingChanged extends AppSettingsEvent {
  final double ovenTargetTemperature;
  final double coreTargetTemperature;
  final DateTime startTime;

  const AppSettingsServerSettingChanged({
    required this.ovenTargetTemperature,
    required this.coreTargetTemperature,
    required this.startTime,
  });

  @override
  List<Object> get props =>
      [ovenTargetTemperature, coreTargetTemperature, startTime];
}

class AppSettingsServerConnectedEvent extends AppSettingsEvent {}

class AppSettingsServerNotConnectedEvent extends AppSettingsEvent {}
