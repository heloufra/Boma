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
  
  bool get isLoaded => status == UserProfileStatus.loaded;
  bool get isInitial => status == UserProfileStatus.initial;
  bool get isError => status == UserProfileStatus.error;
  UserProfile? get user => userProfile;

  Future<void> getUserProfile() async {
    isLoading = true;
    setState();

    try {
      final response = await _api.getUserResponse();
    
      if (response.success) {

          userProfile = UserProfile.fromJson(response.response?.data as Map<String, dynamic>);
    
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

  Future<void> signOut() async {
      return ;
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    isLoading = true;
    setState();

    try {
      final response = await _api.updateUserProfile(userProfile);

      if (response.success) {
        if (response.userProfile != null) {
          this.userProfile = response.userProfile;
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

  // It should only be called when updating the user profile
  void clearError() {
    status = UserProfileStatus.loaded;
  }
}
