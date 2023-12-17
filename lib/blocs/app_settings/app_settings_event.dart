part of 'app_settings_bloc.dart';

sealed class AppSettingsEvent extends Equatable {
  const AppSettingsEvent();

  @override
  List<Object> get props => [];
}

class AppSettingsUserOvenTargetTempChanged extends AppSettingsEvent {
  final double ovenTargetTemperature;

  const AppSettingsUserOvenTargetTempChanged(this.ovenTargetTemperature);
}

class AppSettingsUserCoreTargetTempChanged extends AppSettingsEvent {
  final double coreTargetTemperature;

  const AppSettingsUserCoreTargetTempChanged(this.coreTargetTemperature);
}

class AppSettingsServerConnectedEvent extends AppSettingsEvent {}

class AppSettingsServerNotConnectedEvent extends AppSettingsEvent {}
