import 'package:boma/auth/types/auth.dart';

class AuthAPI {
  Future<AuthResponse> sendOTP(String phoneNumber) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      return AuthResponse(
        success: true,
        message: 'OTP sent successfully',
        token: 'verification-id-123', 
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Failed to send OTP: $e',
      );
    }
  }

  Future<AuthResponse> verifyOTP(PhoneAuthCredential credential) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      return AuthResponse(
        success: true,
        message: 'OTP verified successfully',
        token: 'user-auth-token-123',
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Failed to verify OTP: $e',
      );
    }
  }
}