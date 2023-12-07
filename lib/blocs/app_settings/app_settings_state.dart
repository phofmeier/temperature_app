part of 'app_settings_bloc.dart';

class AppSettingsState extends Equatable {
  final double ovenTargetTemperature;
  final double coreTargetTemperature;

  const AppSettingsState(
      {required this.ovenTargetTemperature,
      required this.coreTargetTemperature});

  @override
  List<Object> get props => [ovenTargetTemperature, coreTargetTemperature];
}

final class AppSettingsInitial extends AppSettingsState {
  const AppSettingsInitial()
      : super(ovenTargetTemperature: 90.0, coreTargetTemperature: 75.0);
}
