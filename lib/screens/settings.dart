import 'package:flutter/material.dart';

import 'package:temperature_app/screens/home.dart';

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
      alignment: Alignment.topCenter,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Settings",
            style: Theme.of(context).textTheme.titleLarge,
          ),
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
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: const BlocTestText(),
    );
  }
}
