import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temperature_app/blocs/app_settings/app_settings_bloc.dart';

class TimeStates extends StatefulWidget {
  const TimeStates({super.key});

  @override
  _TimeStatesState createState() => _TimeStatesState();
}

class _TimeStatesState extends State<TimeStates> {
  late String _currentTimeString;
  DateTime startTime = DateTime.now();
  late String _startTimeString;
  late String _runningTimeString;

  @override
  void initState() {
    _updateTiming();
    _currentTimeString = "00:00:00";
    _startTimeString = "00:00:00";
    _runningTimeString = "00:00:00";
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTiming());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    startTime =
        BlocProvider.of<AppSettingsBloc>(context, listen: true).state.startTime;

    return Column(
      children: [
        _buildHeader(),
        Row(
          children: [
            _buildTableCol(["Current Time", "Start time", "Running time"]),
            const SizedBox(width: 10),
            _buildTableCol(
                [_currentTimeString, _startTimeString, _runningTimeString]),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Text(
      "Timing",
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildTableCol(List<String> names) {
    List<Widget> textList = [];
    for (var name in names) {
      textList.add(
        Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: textList,
    );
  }

  void _updateTiming() {
    setState(() {
      DateTime now = DateTime.now();
      _currentTimeString =
          "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}";
      _startTimeString =
          "${startTime.toLocal().hour.toString().padLeft(2, "0")}:${startTime.toLocal().minute.toString().padLeft(2, "0")}:${startTime.toLocal().second.toString().padLeft(2, "0")}";
      Duration runningTime = now.difference(startTime);
      _runningTimeString =
          "${runningTime.inHours.toString().padLeft(2, "0")}:${runningTime.inMinutes.remainder(60).toString().padLeft(2, "0")}:${runningTime.inSeconds.remainder(60).toString().padLeft(2, "0")}";
    });
  }
}
