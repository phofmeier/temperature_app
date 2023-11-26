import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/blocs/socket_io.dart';
import 'package:temperature_app/blocs/temperature_value_bloc.dart';
import 'package:temperature_app/screens/settings.dart';
import 'package:temperature_app/utils.dart';
import 'package:temperature_app/widgets/gauge.dart';
import 'package:temperature_app/widgets/line_chart.dart';

class MainBlocPage extends StatelessWidget {
  const MainBlocPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [BlocTestButton(), MainPage()],
    );
  }
}

class BlocTestButton extends StatelessWidget {
  const BlocTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () => BlocProvider.of<TemperatureValueBloc>(context)
                .add(TemperatureValueChanged()),
            child: const Text("Increment")),
        TextButton(
            onPressed: () => BlocProvider.of<SocketIOBloc>(context)
                .add(SocketIOConnectEvent()),
            child: const Text("Connect")),
        TextButton(
            onPressed: () => BlocProvider.of<SocketIOBloc>(context)
                .add(SocketIODisconnectEvent()),
            child: const Text("disconnect")),
        Text(
          BlocProvider.of<SocketIOBloc>(context, listen: true).state.toString(),
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }
}

class BlocTestText extends StatelessWidget {
  const BlocTestText({super.key});

  @override
  Widget build(BuildContext context) {
    double value = BlocProvider.of<TemperatureValueBloc>(context, listen: true)
        .state
        .value;
    return Text("$value °C");
  }
}

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Header(),
        TemperatureGauges(),
        Plot(),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Temperature App",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            alignment: Alignment.centerRight,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
            tooltip: "Settings",
          )
        ],
      ),
    );
  }
}

class TemperatureGauges extends StatelessWidget {
  const TemperatureGauges({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SocketIOState tempValue =
        BlocProvider.of<SocketIOBloc>(context, listen: true).state;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Live Temperature",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DoubleGauge(
              innerValue: 0.0,
              outerValue: tempValue.temp_1,
              innerScale: const Pair(-3, 3),
              outerScale: const Pair(30, 100),
              unitNameInner: "°C/h",
              unitNameOuter: "°C",
            ),
            const SizedBox(width: 20),
            DoubleGauge(
              innerValue: 0.0,
              outerValue: tempValue.temp_2,
              innerScale: const Pair(-3, 3),
              outerScale: const Pair(30, 100),
              unitNameInner: "°C/h",
              unitNameOuter: "°C",
            )
          ],
        ),
      ],
    );
  }
}

class Plot extends StatelessWidget {
  const Plot({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(children: [
      SizedBox(width: 20),
      Expanded(child: LineChartTest()),
      SizedBox(width: 20),
    ]);
  }
}
