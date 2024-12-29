import 'package:dio/dio.dart';

class UserProfile {
  final String? name;
  final String? email;
  final String? language;

  UserProfile(
      {required this.name, required this.email, required this.language});
  
  // name: json['name'] ?? "name", email: json['email'] ?? "email", language: json['language'] ?? "language");

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
        name: json['name'] , email: json['email'], language: json['language']);
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "email": email, "language": language};
  }
}

class UserProfileResponse {
  final bool success;
  final String message;
  final Response? response;
  final UserProfile? userProfile;

  UserProfileResponse({
    required this.success,
    required this.message,
    this.response,
    this.userProfile,
    
  });
}