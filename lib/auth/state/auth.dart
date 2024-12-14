import 'package:boma/auth/api/api.dart';
import 'package:june/june.dart';

import '../types/auth.dart';



class AuthState extends JuneState {
  final AuthAPI _api = AuthAPI();

  AuthStatus status = AuthStatus.initial;
  String phoneNumber = '';
  String? verificationId;
  String? errorMessage;
  bool isLoading = false;
  
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isCodeSent => status == AuthStatus.codeSent;
  bool get initial => status == AuthStatus.initial;
  bool get isError => status == AuthStatus.error;
  
  Future<void> sendOTP(String phone) async {
    isLoading = true;
    setState();

    try {
      final response = await _api.sendOTP(phone);
      
      if (response.success) {
        phoneNumber = phone;
        verificationId = response.token;
        status = AuthStatus.codeSent;
      } else {
        status = AuthStatus.error;
        errorMessage = response.message;
      }
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  // Verify OTP
  Future<void> verifyOTP(String smsCode) async {
    isLoading = true;
    setState();

    try {
      final credential = PhoneAuthCredential(
        phoneNumber: phoneNumber,
        smsCode: smsCode,
      );

      final response = await _api.verifyOTP(credential);
      
      if (response.success) {
        status = AuthStatus.authenticated;
        print(status);
        await _saveAuthToken(response.token!);
      } else {
        status = AuthStatus.error;
        errorMessage = response.message;
      }
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  // Sign out
  Future<void> signOut() async {
    isLoading = true;
    setState();

    try {
      // Clear stored data
      phoneNumber = '';
      verificationId = null;
      status = AuthStatus.initial;
      await _clearAuthToken();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  // Private methods
  Future<void> _saveAuthToken(String token) async {
    // Implement secure token storage
    // e.g., using flutter_secure_storage
  }

  Future<void> _clearAuthToken() async {
    // Clear stored token
  }
}