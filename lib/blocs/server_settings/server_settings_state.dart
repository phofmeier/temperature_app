part of 'server_settings_bloc.dart';

class ServerSettingsState extends Equatable {
  final String uri;

  const ServerSettingsState({this.uri = 'http://localhost:5000/js'});

  @override
  List<Object> get props => [uri];
}

final class ServerSettingsInitial extends ServerSettingsState {}
