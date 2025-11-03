// Generated proto models - user-facing idiomatic Dart
// Users interact with these classes, FFI is hidden

class User {
  final int created_at;
  final int id;
  final String username;
  final String email;

  const User({required this.created_at, required this.id, required this.username, required this.email});

  User copyWith({
    int? created_at,
    int? id,
    String? username,
    String? email,
  }) {
    return User(
      created_at: created_at ?? this.created_at,
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }
}

class Post {
  final int created_at;
  final int id;
  final int author_id;
  final int likes;
  final String title;
  final String content;

  const Post({required this.created_at, required this.id, required this.author_id, required this.likes, required this.title, required this.content});

  Post copyWith({
    int? created_at,
    int? id,
    int? author_id,
    int? likes,
    String? title,
    String? content,
  }) {
    return Post(
      created_at: created_at ?? this.created_at,
      id: id ?? this.id,
      author_id: author_id ?? this.author_id,
      likes: likes ?? this.likes,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}

class Response {
  final int affected_id;
  final int success;
  final String message;

  const Response({required this.affected_id, required this.success, required this.message});

  Response copyWith({
    int? affected_id,
    int? success,
    String? message,
  }) {
    return Response(
      affected_id: affected_id ?? this.affected_id,
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }
}

