part of 'server_settings_bloc.dart';

sealed class ServerSettingsEvent extends Equatable {
  const ServerSettingsEvent();

  @override
  List<Object> get props => [];
}

final class ServerSettingsUriChanged extends ServerSettingsEvent {
  final String uri;

  const ServerSettingsUriChanged({required this.uri});
}
