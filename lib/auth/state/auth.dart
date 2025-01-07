import 'package:june/june.dart';
import '../../user/user.dart';
import '../auth.dart';
import '../types/auth.dart';

class AuthState extends JuneState {
  final AuthAPI _api = AuthAPI();
  final UserProfileAPI _userApi = UserProfileAPI();
  late bool _isNewUser;
  late TokenService? tokenService = TokenService();

  AuthStatus status = AuthStatus.authenticated;
  String phoneNumber = '';
  String? verificationId;
  String? errorMessage = "";
  bool isLoading = false;
  late Token _tokens;

  String? otp;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isCodeSent => status == AuthStatus.codeSent;
  bool get initial => status == AuthStatus.initial;
  bool get isError => status == AuthStatus.error;
  bool get isRegistered => status == AuthStatus.registered;
  Token get tokens => _tokens;
  bool get isNewUser=> _isNewUser;

  Future<void> sendOTP(String phone) async {
    isLoading = true;
    setState();

    try {
      final response = await _api.sendOTP(phone);

      if (response.success) {
        phoneNumber = phone;
        otp = response.response?.data["otp"];

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
        smsCode: otp ?? smsCode,
      );

      final response = await _api.verifyOTP(credential);

      if (response.success) {
        status = AuthStatus.authenticated;
        _tokens = Token.fromJson(response.response?.data);

        if (response.response?.data["created"] == false) {
          _isNewUser = true;
        } else {
          _isNewUser = false;
        }
        // get tokens from tokens object
        await _saveAuthToken(_tokens.accessToken, _tokens.refreshToken);
        // store token in secure way
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

  Future<void> signOut() async {
    isLoading = true;
    setState();

    try {
      final res = await _api.signOut();
      if (res.success) {
        phoneNumber = '';
        verificationId = null;
        status = AuthStatus.initial;
        await _clearAuthToken();
      } else {
        status = AuthStatus.error;
        errorMessage = res.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  Future<void> register(String name) async {
    isLoading = true;
    setState();

    try {
      final res = await _userApi.updateUserProfile(
          UserProfile(name: name, email: "email@email.com", language: "en"));
      if (res.success) {
        status = AuthStatus.authenticated;
      } else {
        status = AuthStatus.error;
        errorMessage = res.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  Future<void> _saveAuthToken(String accessToken, String refreshToken) async {
    await tokenService?.saveTokens(
        accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> _clearAuthToken() async {
    await tokenService?.deleteTokens();
  }

  Future<void> registerUser(String name, String avatarURL) async {
    isLoading = true;
    setState();

    try {
      // final user = RegisterUser(name: name, avatarURL: avatarURL);
      // final res = await _api.registerUser(user);

      // if (res.success) {
      status = AuthStatus.authenticated;
      setState();
      // }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }
}
