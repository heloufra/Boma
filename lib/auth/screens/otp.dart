import 'dart:async';
import 'package:boma/auth/state/auth.dart';
import 'package:boma/components/bbutton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<OtpScreen> {
  static const maxSeconds = 300; 
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

  Widget buildPinPut(AuthState state) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).colorScheme.secondary),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Theme.of(context).colorScheme.secondary,
      ),
    );

    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      validator: (s)  {
        return  _verify(state, s) as bool ? null : 'Pin is incorrect';
      },
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: (pin) => (pin),
    );
  }

  void startErrorTimer() {
    errorTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (errorSecondsRemaining == 0) {
        setState(() {
          timer.cancel();
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
          resend = true;
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  Future<bool> _verify(AuthState state, String? s) async {
    setState(() {
      isLoading = true;
    });

    if (s != null) {
      await state.verifyOTP(s);
    }
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
      return false;
    } else if (state.isAuthenticated) {
      timer?.cancel();
      errorTimer?.cancel();
      if (mounted) {
        if (state.isNewUser) {
          context.go('/auth/register');
        } else {
          // UndoableType data = UndoableType("mess", "ss", "sas");
          context.go("/settings");
        }
      }

      return true;
    }

    return false;
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
                buildPinPut(state),
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
                          _verify(state, "4444444");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
