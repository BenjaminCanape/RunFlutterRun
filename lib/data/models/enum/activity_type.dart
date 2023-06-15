enum ActivityType { running, walking, cycling }

extension StringExtension on ActivityType {
  String get name {
    return toString().split('.').last.toUpperCase();
  }
}
