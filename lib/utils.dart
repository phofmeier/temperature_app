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
