import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/repository/temperature_server_repository.dart';

part 'server_settings_event.dart';
part 'server_settings_state.dart';

class ServerSettingsBloc
    extends Bloc<ServerSettingsEvent, ServerSettingsState> {
  final TemperatureServerRepository temperatureServerRepository;

  ServerSettingsBloc({required this.temperatureServerRepository})
      : super(ServerSettingsInitial()) {
    on<ServerSettingsUriChanged>((event, emit) {
      temperatureServerRepository.disconnect();
      temperatureServerRepository.setUri(event.uri);
      temperatureServerRepository.connect();
      emit(ServerSettingsState(uri: event.uri));
    });
  }
}
