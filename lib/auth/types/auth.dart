enum AuthStatus {
  initial,
  codeSent,
  authenticated,
  error
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
  final String? token;

  AuthResponse({
    required this.success,
    this.message,
    this.token,
  });
}