import 'package:june/june.dart';
import '../api/api.dart';
import '../type/user.dart';

enum UserProfileStatus {
  initial,
  loading,
  loaded,
  error,
  updated,
}

class UserProfileState extends JuneState {
  final UserProfileAPI _api = UserProfileAPI();
  UserProfileStatus status = UserProfileStatus.initial;
  String? errorMessage;
  bool isLoading = false;
  UserProfile? userProfile; 

  bool get isInitial => status == UserProfileStatus.initial;
  bool get isError => status == UserProfileStatus.error;
 
  Future<void> getUserProfile() async {
    isLoading = true;
    setState();

    try {
      final response = await _api.getUserResponse();

      if (response.success) {
        userProfile = response.userProfile;
        status = UserProfileStatus.loaded;
      } else {
        status = UserProfileStatus.error;
        errorMessage = response.message;
      }
    } catch (e) {
      status = UserProfileStatus.error;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    isLoading = true;
    setState();

    try {
      final response = await _api.updateUserProfile(userProfile);

      if (response.success) {
        if (response.userProfile != null) {
          this.userProfile = response.userProfile;
          setState();
        }
        status = UserProfileStatus.updated;
      } else {
        status = UserProfileStatus.error;
        errorMessage = response.message;
      }
    } catch (e) {
      status = UserProfileStatus.error;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }
}
