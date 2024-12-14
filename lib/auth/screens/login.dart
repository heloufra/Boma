import 'dart:async';

import 'package:boma/components/bbutton.dart';
import 'package:boma/components/phone_number_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  static const maxSeconds = 4; // 5 minutes in seconds
  int secondsRemaining = maxSeconds;
  Timer? timer;
  bool error = false;
  String errorMsg = '';
  bool isLoading = false; // Add this variable

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining == 0) {
        setState(() {
          timer.cancel();
          // Perform your action here
          error = false;
          errorMsg = "";
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void _login() {
    if (phoneController.text.isEmpty || phoneController.text.length < 9) {
      setState(() {
        error = true;
        errorMsg = "🚨📢🔔 Enter your full phone number";
      });
      startTimer();
    }
    else {
    context.go('/auth/otp', extra: phoneController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            !error ? Theme.of(context).colorScheme.surface : Colors.red,
        title: Text(errorMsg, style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.normal,
              ),),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLoading) // Show loading indicator when isLoading is true
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              )
            else
              const Text(
                "🦉",
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            Text(
              "Welcome to Boma.",
              style: TextStyle(
                fontSize: 32,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Enter your phone number to start ordering!",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            PhoneNumberField(
              controller: phoneController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 0, 8),
                  child: BButton(
                    text: 'Login',
                    onTap: () {
                        _login();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
