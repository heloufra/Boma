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
  // final String? verificationId;
  final String? smsCode;

  PhoneAuthCredential({
    required this.phoneNumber,
    // this.verificationId,
    this.smsCode,
  });
}

class AuthResponse {
  final bool success;
  final String? message;
  Response? response;
  AuthResponse({
    required this.success,
    this.message,
    this.response
  });
}