extension Double2 on double {
  String toPrettyString() {
    double fraction = this - toInt();
    if (fraction == 0) return toStringAsFixed(0);
    final result = toStringAsPrecision(3);
    if (result.split('').last == '0') return toStringAsPrecision(2);
    return toStringAsPrecision(3);
  }
}
