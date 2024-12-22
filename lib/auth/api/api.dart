import 'package:boma/auth/types/auth.dart';
import 'package:boma/dio.dart';
import 'package:dio/dio.dart';

class AuthAPI {
  final dioClient = DioClient();

  Future<AuthResponse> sendOTP(String phoneNumber) async {
    try {
      final response = await dioClient
          .post('/users/login/', data: {"phone_number": phoneNumber});
      return AuthResponse(
          success: true,
          message: 'OTP sent successfully',
          response: response,
          isUser: response.data["is_user"]);
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return AuthResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }

  Future<AuthResponse> verifyOTP(PhoneAuthCredential credential) async {
    try {
      final response = await dioClient.post('/users/otp/', data: {
        "phone_number": credential.phoneNumber,
        "otp": credential.smsCode
      });

      return AuthResponse(
          success: response.statusCode == 200,
          message: 'OTP sent successfully',
          response: response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 400) {
        return AuthResponse(
          success: false,
          message: '🚨📢🔔 OTP is wrong! try agian.',
        );
      }
      String message = DioClient.handleDioError(e);
      return AuthResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }

  Future<AuthResponse> refreshToken(String refresh) async {
    try {
      final response = await dioClient
          .post('/users/jwt/refresh/', data: {"refresh": refresh});
      return AuthResponse(
          success: response.statusCode == 200,
          message: 'OTP sent successfully',
          response: response);
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return AuthResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }

  Future<AuthResponse> registerUser(RegisterUser user) async {
    try {
      final response =
          await dioClient.put('/users/account/', data: {"name": user.name});
      return AuthResponse(
          success: response.statusCode == 200,
          message: 'OTP sent successfully',
          response: response);
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return AuthResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }

  Future<AuthResponse> signOut() async {
    try {
      final response = await dioClient.post('/users/logout/');
      return AuthResponse(
        success: response.statusCode == 200,
        message: 'OTP sent successfully',
      );
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return AuthResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }
}
