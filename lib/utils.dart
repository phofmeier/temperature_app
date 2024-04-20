import 'package:flutter/material.dart';

class Pair<T> {
  final T first;
  final T second;

  const Pair(this.first, this.second);

  @override
  String toString() => '$runtimeType: $first, $second';
}

class Measurement {
  final DateTime timestamp;
  final double value;

  const Measurement(this.timestamp, this.value);
}

Container buildWidgetContainer(BuildContext context, Widget child) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20))),
    margin: const EdgeInsets.all(8.0),
    child: child,
  );
}
