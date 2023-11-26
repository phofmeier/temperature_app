import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/blocs/socket_io.dart';
import 'package:temperature_app/blocs/temperature_value_bloc.dart';
import 'package:temperature_app/screens/home.dart';

void main() {
  // Bloc.observer = const TemperatureValueObserver();
  Bloc.observer = const SocketIOObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TemperatureValueBloc>(
            create: (context) => TemperatureValueBloc()),
        BlocProvider<SocketIOBloc>(
          create: (context) => SocketIOBloc()..add(SocketIOConnectEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Temperature App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainBlocPage(),
      ),
    );
  }
}
