// Generated proto models - user-facing idiomatic Dart
// Users interact with these classes, FFI is hidden

class User {
  final int user_id;
  final int date_of_birth;
  final int created_at;
  final int updated_at;
  final double account_balance;
  final int reputation_score;
  final String username;
  final String email;
  final String first_name;
  final String last_name;
  final String display_name;
  final String bio;
  final String avatar_url;
  final int is_verified;
  final int is_premium;

  const User({required this.user_id, required this.date_of_birth, required this.created_at, required this.updated_at, required this.account_balance, required this.reputation_score, required this.username, required this.email, required this.first_name, required this.last_name, required this.display_name, required this.bio, required this.avatar_url, required this.is_verified, required this.is_premium});

  User copyWith({
    int? user_id,
    int? date_of_birth,
    int? created_at,
    int? updated_at,
    double? account_balance,
    int? reputation_score,
    String? username,
    String? email,
    String? first_name,
    String? last_name,
    String? display_name,
    String? bio,
    String? avatar_url,
    int? is_verified,
    int? is_premium,
  }) {
    return User(
      user_id: user_id ?? this.user_id,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      account_balance: account_balance ?? this.account_balance,
      reputation_score: reputation_score ?? this.reputation_score,
      username: username ?? this.username,
      email: email ?? this.email,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      display_name: display_name ?? this.display_name,
      bio: bio ?? this.bio,
      avatar_url: avatar_url ?? this.avatar_url,
      is_verified: is_verified ?? this.is_verified,
      is_premium: is_premium ?? this.is_premium,
    );
  }
}

class Post {
  final int post_id;
  final int user_id;
  final int created_at;
  final int updated_at;
  final int view_count;
  final int like_count;
  final int comment_count;
  final String username;
  final String title;
  final String content;
  final int is_edited;
  final int is_pinned;

  const Post({required this.post_id, required this.user_id, required this.created_at, required this.updated_at, required this.view_count, required this.like_count, required this.comment_count, required this.username, required this.title, required this.content, required this.is_edited, required this.is_pinned});

  Post copyWith({
    int? post_id,
    int? user_id,
    int? created_at,
    int? updated_at,
    int? view_count,
    int? like_count,
    int? comment_count,
    String? username,
    String? title,
    String? content,
    int? is_edited,
    int? is_pinned,
  }) {
    return Post(
      post_id: post_id ?? this.post_id,
      user_id: user_id ?? this.user_id,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      view_count: view_count ?? this.view_count,
      like_count: like_count ?? this.like_count,
      comment_count: comment_count ?? this.comment_count,
      username: username ?? this.username,
      title: title ?? this.title,
      content: content ?? this.content,
      is_edited: is_edited ?? this.is_edited,
      is_pinned: is_pinned ?? this.is_pinned,
    );
  }
}

