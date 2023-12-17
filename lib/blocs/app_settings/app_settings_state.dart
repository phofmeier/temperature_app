part of 'app_settings_bloc.dart';

enum AppSettingsStatus {
  uninitialized,
  notConnected,
  synchronized,
  notSynchronized,
}

class AppSettingsState extends Equatable {
  final AppSettingsStatus status;
  final double ovenTargetTemperature;
  final double coreTargetTemperature;

  const AppSettingsState(
      {required this.status,
      required this.ovenTargetTemperature,
      required this.coreTargetTemperature});

  @override
  List<Object> get props =>
      [status, ovenTargetTemperature, coreTargetTemperature];
}

final class AppSettingsInitial extends AppSettingsState {
  const AppSettingsInitial()
      : super(
            status: AppSettingsStatus.uninitialized,
            ovenTargetTemperature: 90.0,
            coreTargetTemperature: 75.0);
}
