import 'dart:async';
import 'package:boma/auth/state/auth.dart';
import 'package:boma/components/bbutton.dart';
import 'package:boma/components/otp.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';

class OtpScreen extends StatefulWidget {
  late String phoneNumber;
  OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<OtpScreen> {
  static const maxSeconds = 300; // 5 minutes in seconds
  int secondsRemaining = maxSeconds;
  int errorSecondsRemaining = 5;

  bool resend = false;
  Timer? timer;
  Timer? errorTimer;
  bool error = false;
  String errorMsg = '';
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startErrorTimer() {
    errorTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (errorSecondsRemaining == 0) {
        setState(() {
          timer.cancel();
          // Perform your action here
          error = false;
          errorMsg = "";
          errorSecondsRemaining = 5;
        });
      } else {
        setState(() {
          errorSecondsRemaining--;
        });
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining == 0) {
        setState(() {
          timer.cancel();
          // Perform your action here
          resend = true;
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  Future<void> _verify(AuthState state) async {
    if (controller.text.isEmpty || controller.text.length < 6) {
      setState(() {
        error = true;
        errorMsg = '🚨📢🔔 Enter full digits of your OTP';
      });
      startErrorTimer();
    } else {
      setState(() {
        isLoading = true;
      });

      await state.verifyOTP(controller.text);
      if (state.isLoading) {
        setState(() {
          isLoading = true;
        });
      } else if (state.isError) {
        setState(() {
          isLoading = false;
          error = true;
          errorMsg = state.errorMessage ?? "";
        });
      } else if (state.isAuthenticated) {
        timer?.cancel();
        errorTimer?.cancel();
        context.go('/auth/register');
      }
    }
  }

  void _resend(AuthState state) async {
    await state.sendOTP(controller.text);
    if (state.isCodeSent) {
      timer?.cancel();
      setState(() {
        resend = false;
        secondsRemaining = maxSeconds;
      });
      startTimer();
    } else if (state.isLoading) {
      setState(() {
        isLoading = true;
      });
    } else if (state.isError) {
      setState(() {
        isLoading = false;
        error = state.isError;
        errorMsg = state.errorMessage ?? "";
      });
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isLoading) // Show loading indicator when isLoading is true
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  )
                else
                  Text(
                    "Enter your OTP to start using the app",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 50),
                OtpField(
                  controller: controller,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 0, 8),
                      child: (!resend)
                          ? Text(
                              '${(secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(secondsRemaining % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : BButton(
                              text: 'Resend',
                              onTap: () {
                                _resend(state);
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 0, 8),
                      child: BButton(
                        text: 'Verify',
                        onTap: () {
                          _verify(state);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        )
        );
  }
}
