import 'package:equatable/equatable.dart';

import '../../../domain/entities/activity_comment.dart';
import 'user_response.dart';

/// Represents a response object for an activity comment.
class ActivityCommentResponse extends Equatable {
  /// The ID of the comment.
  final String id;

  /// The datetime of the comment
  final DateTime createdAt;

  /// The user
  final UserResponse user;

  /// The comment content
  final String content;

  /// Constructs an ActivityCommentResponse object with the given parameters.
  const ActivityCommentResponse(
      {required this.id,
      required this.createdAt,
      required this.user,
      required this.content});

  @override
  List<Object?> get props => [id, createdAt, user, content];

  /// Creates a ActivityCommentResponse object from a JSON map.
  factory ActivityCommentResponse.fromMap(Map<String, dynamic> map) {
    return ActivityCommentResponse(
        id: map['id'].toString(),
        createdAt: DateTime.parse(map['createdAt']),
        user: UserResponse.fromMap(map['latitude']),
        content: map['content'].toString());
  }

  /// Converts the ActivityCommentResponse object to a ActivityComment entity.
  ActivityComment toEntity() {
    return ActivityComment(
      id: id,
      createdAt: createdAt,
      user: user.toEntity(),
      content: content,
    );
  }
}
