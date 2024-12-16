import 'package:boma/auth/api/api.dart';
import 'package:june/june.dart';
import '../auth.dart';
import '../types/auth.dart';

class AuthState extends JuneState {
  final AuthAPI _api = AuthAPI();

  AuthStatus status = AuthStatus.initial;
  String phoneNumber = '';
  String? verificationId;
  String? errorMessage = "";
  bool isLoading = false;
  late Token _tokens;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isCodeSent => status == AuthStatus.codeSent;
  bool get initial => status == AuthStatus.initial;
  bool get isError => status == AuthStatus.error;
  bool get isRegistered => status == AuthStatus.registered;
  Token get tokens => _tokens;


  Future<void> sendOTP(String phone) async {
    isLoading = true;
    setState();

    try {
      final response = await _api.sendOTP(phone);

      if (response.success) {
        phoneNumber = phone;
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
          _tokens = Token.fromJson(response.response?.data);
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

  Future<void> registerUser(String name, String avatarURL) async {
    isLoading = true;
    setState();

    try {
      final user = RegisterUser(name: name, avatarURL: avatarURL);
      final res = await _api.registerUser(user);

      if (res.success) {
        status = AuthStatus.registered;
        setState();
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }
}
