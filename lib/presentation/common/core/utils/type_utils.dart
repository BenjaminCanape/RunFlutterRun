extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension DoubleFormatting on double {
  String formatAsFixed(int fractionDigits) => toStringAsFixed(fractionDigits);
}
