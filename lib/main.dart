import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/blocs/app_settings/app_settings_bloc.dart';
import 'package:temperature_app/blocs/bloc_observer.dart';
import 'package:temperature_app/blocs/server_connection/server_connection_bloc.dart';
import 'package:temperature_app/blocs/server_settings/server_settings_bloc.dart';
import 'package:temperature_app/blocs/temperature_value_bloc.dart';
import 'package:temperature_app/repository/temperature_server_repository.dart';
import 'package:temperature_app/screens/home.dart';

void main() {
  Bloc.observer = const GlobalBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TemperatureServerRepository()..connect(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TemperatureValueBloc>(
            create: (context) => TemperatureValueBloc(
              temperatureServerRepository:
                  RepositoryProvider.of<TemperatureServerRepository>(context),
            ),
          ),
          BlocProvider<ServerSettingsBloc>(
            create: (context) => ServerSettingsBloc(
              temperatureServerRepository:
                  RepositoryProvider.of<TemperatureServerRepository>(context),
            ),
          ),
          BlocProvider<AppSettingsBloc>(
            create: (context) => AppSettingsBloc(
              temperatureServerRepository:
                  RepositoryProvider.of<TemperatureServerRepository>(context),
            ),
          ),
          BlocProvider<ServerConnectionBloc>(
            create: (context) => ServerConnectionBloc(
              temperatureServerRepository:
                  RepositoryProvider.of<TemperatureServerRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Temperature App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MainPage(),
        ),
      ),
    );
  }
}
