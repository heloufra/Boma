import 'package:boma/auth/types/auth.dart';
import 'package:boma/dio.dart';

class AuthAPI {
  final dioClient = DioClient();

  Future<AuthResponse> sendOTP(String phoneNumber) async {
    try {
      final response = await dioClient
          .post('/users/login/', data: {"phone_number": phoneNumber});
      return AuthResponse(
        success: response.statusCode == 200,
        message: 'OTP sent successfully',
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
      final response = await dioClient
          .post('/users/otp/', data: {"phone_number": credential.phoneNumber, "otp": credential.smsCode});

      
      return AuthResponse(
        success: response.statusCode == 200,
        message: 'OTP sent successfully',
        response: response
      );
      
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Failed to verify OTP: $e',
      );
    }
  }

  Future<AuthResponse> registerUser(RegisterUser user) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return AuthResponse(success: true, message: "welcome to the club");
    } catch (e) {
      return AuthResponse(
          success: true, message: "go away we do not want you here");
    }
  }
}
