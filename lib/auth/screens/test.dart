// login_page.dart
import 'package:boma/auth/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:june/june.dart';

class LoginPage extends StatelessWidget {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Authentication')),
      body: JuneBuilder(
        () => AuthState(),
        builder: (state) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.isLoading)
                const CircularProgressIndicator()
              else if (state.initial)
                _buildPhoneInput(state)
              else if (state.isCodeSent)
                _buildOTPInput(state)
              else if (state.isAuthenticated)
                _buildAuthenticatedView(state),
              if (state.errorMessage != null)
                Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput(AuthState state) {
    return Column(
      children: [
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
          ),
        ),
        ElevatedButton(
          onPressed: () => state.sendOTP(phoneController.text),
          child: const Text('Send OTP'),
        ),
      ],
    );
  }

  Widget _buildOTPInput(AuthState state) {
    return Column(
      children: [
        TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter OTP',
          ),
        ),
        ElevatedButton(
          onPressed: () => state.verifyOTP(otpController.text),
          child: const Text('Verify OTP'),
        ),
      ],
    );
  }

  Widget _buildAuthenticatedView(AuthState state) {
    return Column(
      children: [
        Text('Authenticated as ${state.phoneNumber}'),
        ElevatedButton(
          onPressed: () => state.signOut(),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}