
class User {
  final String id;
  final String avatar;
  final String name;
  final String phone;
  final String accessToken;
  final String refreshToken;

  User({required this.id, required this.avatar, required this.phone, required this.accessToken, required this.refreshToken, required this.name});
}