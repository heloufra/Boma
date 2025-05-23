import 'dart:async';
import 'package:boma/components/bbutton.dart';
import 'package:boma/user/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';
import '../../components/btextfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _emailController =
      TextEditingController(text: "");
  String _selectedLanguage = "en";
  late Color s;

  static const maxSeconds = 4;
  int secondsRemaining = maxSeconds;
  Timer? timer;
  bool error = false;
  String errorMsg = '';
  bool isLoading = false;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = June.getState(() => UserProfileState());
      _getUserProfile(state);
    });
  }

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

  void _getUserProfile(UserProfileState state) async {
    await state.getUserProfile();
    if (state.isError) {
      setState(() {
        error = true;
        errorMsg = state.errorMessage ?? "";
      });
    } else if (state.isLoading) {
      setState(() {
        isLoading = true;
      });
    } else if (state.isLoaded) {
      setState(() {
        userProfile = state.user;
        if (userProfile != null) {
          _nameController.text = userProfile?.name ?? "";
          _emailController.text = userProfile?.email ?? "";
          setState(() {
            _selectedLanguage = userProfile?.language ?? "en";
          });
        }
      });
    }
  }

  Future<void> save() async {
    var state = June.getState(() => UserProfileState());

    if (userProfile?.name == _nameController.text &&
        userProfile?.email == _emailController.text &&
        userProfile?.language == _selectedLanguage) {
      if (mounted) {
        context.go('/settings');
      }
      return;
    }

    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      setState(() {
        error = true;
        errorMsg = "Full ...";
      });

      startTimer();

      return;
    }

    try {
      await state.updateUserProfile(UserProfile(
          name: _nameController.text,
          email: _emailController.text,
          language: _selectedLanguage));

      if (state.isError) {
        setState(() {
          error = true;
          errorMsg = state.errorMessage ?? "Error";
        });
        state.clearError();
        startTimer();
        return;
      }

      if (mounted) {
        context.go('/settings');
      }
    } catch (e) {
      setState(() {
        error = true;
        errorMsg = e.toString();
      });
      startTimer();
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
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  save();
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 22),
              ),
            ),
          ],
        ),
        body: JuneBuilder(
          () => UserProfileState(),
          builder: (state) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // GlobalKey for form validation
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Btextfield(
                      controller: _nameController,
                      labelText: 'Full Name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Btextfield(
                      controller: _emailController,
                      labelText: "Email",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email cannot be empty';
                        }
                        final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$'); // Simple email regex
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedLanguage,
                      decoration: InputDecoration(
                        labelText: 'Language',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLanguage = newValue!;
                        });
                      },
                      items: <String>['en', 'ar']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    BButton(text: "Save", onTap: () => {
                        if (_formKey.currentState?.validate() ?? false) {
                          save()
                        }
                    }),
                    
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
