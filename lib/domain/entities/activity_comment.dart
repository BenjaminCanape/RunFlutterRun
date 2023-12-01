import 'package:equatable/equatable.dart';

import 'user.dart';

/// Represents an activity comment.
class ActivityComment extends Equatable {
  /// The ID of the activityComment.
  final String id;

  /// The datetime of the comment.
  final DateTime createdAt;

  /// The user
  final User user;

  /// The content
  final String content;

  /// Constructs a Location object with the given parameters.
  const ActivityComment({
    required this.id,
    required this.createdAt,
    required this.user,
    required this.content,
  });

  @override
  List<Object?> get props => [id, createdAt, user, content];
}
