import 'package:boma/dio.dart';
import 'package:boma/user/type/user.dart';
import 'package:dio/dio.dart';

class UserProfileAPI {
  final dioClient = DioClient();

  Future<UserProfileResponse> getUserResponse() async {
    try {
      final response = await dioClient.get('/c/account/');
      final UserProfile user = UserProfile.fromJson(response.data as Map<String, dynamic>);

      return UserProfileResponse(
        success: true,
        message: 'Addresses fetched successfully',
        response: response,
        userProfile: user,
      );
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return UserProfileResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }

  Future<UserProfileResponse> updateUserProfile( UserProfile user) async {
    try {
      final response = await dioClient.put(
        '/c/account/',
        data: user.toJson(),
      );

      return UserProfileResponse(
        success: true,
        message: 'Address updated successfully',
        response: response,
        userProfile: UserProfile.fromJson(response.data),
      );
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return UserProfileResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }

  Future<UserProfileResponse> signOut() async {
    try {
      final response = await dioClient.post('/auth/logout/', data : null,);

      return UserProfileResponse(
        success: true,
        message: 'Sign out successfully',
        response: response,
      );
    } on DioException catch (e) {
       String message = DioClient.handleDioError(e);
      return UserProfileResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }
}