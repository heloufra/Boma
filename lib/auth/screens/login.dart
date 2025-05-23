import 'dart:async';
import 'package:boma/auth/state/auth.dart';
import 'package:boma/components/bbutton.dart';
import 'package:boma/components/phone_number_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  static const maxSeconds = 4;
  int secondsRemaining = maxSeconds;
  Timer? timer;
  bool error = false;
  String errorMsg = '';
  bool isLoading = false;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining == 0) {
        setState(() {
          timer.cancel();
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

  Future<void> _login(AuthState state) async {
    if (phoneController.text.isEmpty || phoneController.text.length < 9) {
      setState(() {
        error = true;
        errorMsg = "🚨📢🔔 Enter your full phone number";
      });
      startTimer();
    } else if (phoneController.text[0] != '6' &&
        phoneController.text[0] != '7' &&
        phoneController.text[0] != '8') {
      setState(() {
        error = true;
        errorMsg = "🚨📢🔔 Enter a correct phone number";
      });
      startTimer();
    } else {
      await state.sendOTP(phoneController.text);
      if (state.isCodeSent) {
        if (!mounted) return;
        context.go('/auth/otp', extra: phoneController.text);
      } else {
        setState(() {
          error = state.isError;
          errorMsg = state.errorMessage ?? "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:
              !error ? Theme.of(context).colorScheme.surface : Colors.red,
          title: Text(
            errorMsg,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: JuneBuilder(
          () => AuthState(),
          builder: (state) => Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.isLoading)
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                // else
                //   const Text(
                //     "🦉",
                //     style: TextStyle(
                //       fontSize: 70,
                //       fontWeight: FontWeight.bold,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // const SizedBox(height: 20),
                Text(
                  "Boma.",
                  style: TextStyle(
                    fontSize: 82,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    // backgroundColor: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationColor:  Theme.of(context).colorScheme.secondary, // optional
                    decorationThickness: 2, // optional
                    // decorationStyle: TextDecorationStyle.,
                  ),
                  textAlign: TextAlign.start,
                ),
                Text(
                  "Local eats, at your door. Fast, fresh, and from your favorites!\nEnter your phone number to start ordering!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 24),
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
                          _login(state);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ));
  }
}
