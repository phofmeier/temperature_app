import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/blocs/temperature_value_bloc.dart';
import 'package:temperature_app/screens/settings.dart';
import 'package:temperature_app/utils.dart';
import 'package:temperature_app/widgets/connection_status.dart';
import 'package:temperature_app/widgets/gauge.dart';
import 'package:temperature_app/widgets/line_chart.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const ConnectionStatusIcon(),
              IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Settings()),
                  );
                },
                tooltip: "Settings",
              ),
            ],
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
    var tempValueState =
        BlocProvider.of<TemperatureValueBloc>(context, listen: true).state;
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
              outerValue: tempValueState.value,
              innerScale: const Pair(-3, 3),
              outerScale: const Pair(30, 100),
              unitNameInner: "°C/h",
              unitNameOuter: "°C",
            ),
            const SizedBox(width: 20),
            DoubleGauge(
              innerValue: tempValueState.value,
              outerValue: 0.0,
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
