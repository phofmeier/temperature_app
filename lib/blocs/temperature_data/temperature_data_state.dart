part of 'temperature_data_bloc.dart';

sealed class TemperatureDataState extends Equatable {
  const TemperatureDataState(
    this.currentCoreTemp,
    this.currentOvenTemp,
    this.currentCoreChange,
    this.currentOvenChange,
  );

  final double currentCoreTemp;
  final double currentOvenTemp;

  final double currentCoreChange;
  final double currentOvenChange;

  @override
  List<Object> get props => [
        currentCoreTemp,
        currentOvenTemp,
        currentCoreChange,
        currentOvenChange,
      ];
}

final class TemperatureDataInitial extends TemperatureDataState {
  const TemperatureDataInitial() : super(0.0, 0.0, 0.0, 0.0);
}
