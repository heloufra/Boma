import 'package:dio/dio.dart';

enum AuthStatus {
  initial,
  codeSent,
  authenticated,
  registered,
  error
}

class RegisterUser {
  final String name;
  final String avatarURL;

  RegisterUser({required this.name, this.avatarURL = ""});
}

class PhoneAuthCredential {
  final String phoneNumber;
  final String? smsCode;

  PhoneAuthCredential({
    required this.phoneNumber,
    this.smsCode,
  });
}

class AuthResponse {
  final bool success;
  final String? message;
  final bool? isUser;
  Response? response;
  AuthResponse({
    required this.success,
    this.message,
    this.response,
    this.isUser
  });
}