import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.createdAt,
  }) : assert(email.contains('@'), 'Invalid email address');

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.mock() {
    return User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: 'mock@example.com',
      name: 'Mock User',
      avatar: 'https://i.pravatar.cc/150?img=1',
      createdAt: DateTime.now(),
    );
  }
}
