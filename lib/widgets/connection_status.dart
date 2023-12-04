import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/blocs/server_connection/server_connection_bloc.dart';
import 'package:temperature_app/repository/temperature_server_repository.dart';

class ConnectionStatusIcon extends StatelessWidget {
  const ConnectionStatusIcon({super.key});

  @override
  Widget build(BuildContext context) {
    ServerConnectionState connectionState =
        BlocProvider.of<ServerConnectionBloc>(context, listen: true).state;
    IconData connectionIcon = Icons.not_interested_rounded;
    if (connectionState.temperatureServerConnectionStatus.state ==
        TemperatureServerConnectionState.connected) {
      connectionIcon = Icons.compare_arrows_rounded;
    }

    return Tooltip(
      message:
          "${connectionState.temperatureServerConnectionStatus.state.name}, ${connectionState.temperatureServerConnectionStatus.message}",
      child: Icon(
        connectionIcon,
      ),
    );
  }
}
