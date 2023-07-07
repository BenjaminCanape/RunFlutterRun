import 'package:equatable/equatable.dart';

/// Represents a failure object that can be used for error handling and reporting.
class Failure extends Equatable {
  /// The error message associated with the failure.
  final String message;

  /// Constructs a Failure object with the given [message].
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  bool get stringify => true;
}
