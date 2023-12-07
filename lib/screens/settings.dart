import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/blocs/app_settings/app_settings_bloc.dart';
import 'package:temperature_app/blocs/server_settings/server_settings_bloc.dart';

import 'package:temperature_app/widgets/connection_status.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsHeader(),
        SettingsPage(),
      ],
    );
  }
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

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
            "Settings",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const ConnectionStatusIcon(),
              IconButton(
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                tooltip: "Return",
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text("Server", style: Theme.of(context).textTheme.headlineSmall),
          const ServerUriSetting(),
          const Divider(),
          Text("Application", style: Theme.of(context).textTheme.headlineSmall),
          const AppSettingOvenTarget(),
          const AppSettingCoreTarget(),
        ],
      ),
    );
  }
}

class ServerUriSetting extends StatelessWidget {
  const ServerUriSetting({super.key});

  @override
  Widget build(BuildContext context) {
    ServerSettingsBloc serverSettings =
        BlocProvider.of<ServerSettingsBloc>(context, listen: true);

    TextEditingController textController =
        TextEditingController(text: serverSettings.state.uri);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.public),
        title: const Text("Server URI"),
        subtitle: TextField(
          keyboardType: TextInputType.url,
          controller: textController,
          onEditingComplete: () {
            serverSettings
                .add(ServerSettingsUriChanged(uri: textController.text));
          },
        ),
      ),
    );
  }
}

class AppSettingOvenTarget extends StatelessWidget {
  const AppSettingOvenTarget({super.key});

  @override
  Widget build(BuildContext context) {
    AppSettingsBloc appSettings =
        BlocProvider.of<AppSettingsBloc>(context, listen: true);

    TextEditingController textController = TextEditingController(
        text: appSettings.state.ovenTargetTemperature.toStringAsFixed(2));

    return Card(
      child: ListTile(
        leading: const Icon(Icons.thermostat),
        title: const Text("Oven target temperature [°C]"),
        subtitle: TextField(
          controller: textController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'(^-?\d*\.?\d*)'))
          ],
          onEditingComplete: () {
            appSettings.add(AppSettingsOvenTargetTempChanged(
                double.parse(textController.text)));
          },
        ),
      ),
    );
  }
}

class AppSettingCoreTarget extends StatelessWidget {
  const AppSettingCoreTarget({super.key});

  @override
  Widget build(BuildContext context) {
    AppSettingsBloc appSettings =
        BlocProvider.of<AppSettingsBloc>(context, listen: true);

    TextEditingController textController = TextEditingController(
        text: appSettings.state.coreTargetTemperature.toStringAsFixed(2));

    return Card(
      child: ListTile(
        leading: const Icon(Icons.thermostat),
        title: const Text("Core target temperature [°C]"),
        subtitle: TextField(
          controller: textController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'(^-?\d*\.?\d*)'))
          ],
          onEditingComplete: () {
            appSettings.add(AppSettingsCoreTargetTempChanged(
                double.parse(textController.text)));
          },
        ),
      ),
    );
  }
}
