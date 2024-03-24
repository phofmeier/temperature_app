part of 'temperature_data_bloc.dart';

sealed class TemperatureDataEvent extends Equatable {
  const TemperatureDataEvent();

  @override
  List<Object> get props => [];
}

final class NewTemperatureDataReceived extends TemperatureDataEvent {
  const NewTemperatureDataReceived(
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
