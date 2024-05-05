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

  final DateTime startTime;

  final double ovenMinValue;
  final double ovenMaxValue;
  final double coreMinValue;
  final double coreMaxValue;

  final double ovenLowTempTol = 10.0;
  final double ovenHighTempTol = 10.0;
  final double coreLowTempTol = 5.0;

  final double tempChangeMaxValue = 1.0;

  const AppSettingsState({
    required this.status,
    required this.ovenTargetTemperature,
    required this.coreTargetTemperature,
    required this.startTime,
    required this.ovenMinValue,
    required this.ovenMaxValue,
    required this.coreMinValue,
    required this.coreMaxValue,
  });

  @override
  List<Object> get props => [
        status,
        ovenTargetTemperature,
        coreTargetTemperature,
        startTime,
        ovenMinValue,
        ovenMaxValue,
        coreMinValue,
        coreMaxValue,
      ];

  AppSettingsState copyWith({
    AppSettingsStatus? status,
    double? ovenTargetTemperature,
    double? coreTargetTemperature,
    DateTime? startTime,
    double? ovenMinValue,
    double? ovenMaxValue,
    double? coreMinValue,
    double? coreMaxValue,
  }) {
    return AppSettingsState(
      status: status ?? this.status,
      ovenTargetTemperature:
          ovenTargetTemperature ?? this.ovenTargetTemperature,
      coreTargetTemperature:
          coreTargetTemperature ?? this.coreTargetTemperature,
      startTime: startTime ?? this.startTime,
      ovenMinValue: ovenMinValue ?? this.ovenMinValue,
      ovenMaxValue: ovenMaxValue ?? this.ovenMaxValue,
      coreMinValue: coreMinValue ?? this.coreMinValue,
      coreMaxValue: coreMaxValue ?? this.coreMaxValue,
    );
  }
}

final class AppSettingsInitial extends AppSettingsState {
  AppSettingsInitial()
      : super(
          status: AppSettingsStatus.uninitialized,
          ovenTargetTemperature: 90.0,
          coreTargetTemperature: 75.0,
          startTime: DateTime.now(),
          ovenMinValue: 20.0,
          ovenMaxValue: 180.0,
          coreMinValue: 10.0,
          coreMaxValue: 120.0,
        );
}
