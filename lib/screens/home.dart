import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/blocs/app_settings/app_settings_bloc.dart';
import 'package:temperature_app/blocs/temperature_data/temperature_data_bloc.dart';
import 'package:temperature_app/repository/temperature_server_repository.dart';
import 'package:temperature_app/screens/settings.dart';
import 'package:temperature_app/utils.dart';
import 'package:temperature_app/widgets/connection_status.dart';
import 'package:temperature_app/widgets/gauge.dart';
import 'package:temperature_app/widgets/line_chart.dart';
import 'package:temperature_app/widgets/time_state.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TemperatureDataBloc>(
      create: (context) => TemperatureDataBloc(
        temperatureServerRepository:
            RepositoryProvider.of<TemperatureServerRepository>(context),
      ),
      child: const Column(
        children: [
          Header(),
          TemperatureGauges(),
          Plot(),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
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
        BlocProvider.of<TemperatureDataBloc>(context, listen: true).state;
    var appSettingsState =
        BlocProvider.of<AppSettingsBloc>(context, listen: true).state;
    double maxGaugeWidth = MediaQuery.of(context).size.height;
    return Column(
      children: [
        // Text(
        //   "Live Temperature",
        //   style: Theme.of(context).textTheme.titleLarge,
        // ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return buildWidgetContainer(
                    context,
                    DoubleGauge(
                      innerValue: tempValueState.currentOvenChange * 60.0,
                      outerValue: tempValueState.currentOvenTemp,
                      innerSettings: GaugeSettings(
                          scale: Pair(
                            -appSettingsState.tempChangeMaxValue,
                            appSettingsState.tempChangeMaxValue,
                          ),
                          unitName: "°C/min"),
                      outerSettings: GaugeSettings(
                        scale: Pair(
                          appSettingsState.ovenMinValue,
                          appSettingsState.ovenMaxValue,
                        ),
                        unitName: "°C",
                        targetVal: appSettingsState.ovenTargetTemperature,
                        targetTolHigh: appSettingsState.ovenHighTempTol,
                        targetTolLow: appSettingsState.ovenLowTempTol,
                      ),
                      width: min(constraints.maxWidth, maxGaugeWidth),
                    ),
                  );
                },
              ),
            ),
            buildWidgetContainer(
              context,
              const TimeStates(),
            ),
            // const SizedBox(width: 20),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return buildWidgetContainer(
                    context,
                    DoubleGauge(
                      innerValue: tempValueState.currentCoreChange * 60.0,
                      outerValue: tempValueState.currentCoreTemp,
                      innerSettings: GaugeSettings(
                          scale: Pair(
                            -appSettingsState.tempChangeMaxValue,
                            appSettingsState.tempChangeMaxValue,
                          ),
                          unitName: "°C/min"),
                      outerSettings: GaugeSettings(
                        scale: Pair(
                          appSettingsState.coreMinValue,
                          appSettingsState.coreMaxValue,
                        ),
                        unitName: "°C",
                        targetVal: appSettingsState.coreTargetTemperature,
                        targetTolLow: appSettingsState.coreLowTempTol,
                      ),
                      width: min(constraints.maxWidth, maxGaugeWidth),
                    ),
                  );
                },
              ),
            ),
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
    return Expanded(
      child: buildWidgetContainer(
        context,
        const LineChartTest(),
      ),
    );
  }
}
