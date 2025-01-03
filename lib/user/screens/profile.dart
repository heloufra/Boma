import 'dart:async';
import 'package:boma/user/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';
import '../../components/btextfield.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: "hamza");
  final TextEditingController _emailController =
      TextEditingController(text: "hamza@gmail.com");
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

  Future<void> logout() async {
    var state = June.getState(() => UserProfileState());

    try {
      await state.signOut();
      if (mounted) {
        context.go("/auth");
      }
    } catch (e) {
      setState(() {
        error = true;
        errorMsg = e.toString();
      });
      startTimer();
    }
  }

  Future<void> save() async {
    var state = June.getState(() => UserProfileState());

    if (userProfile?.name == _nameController.text &&
        userProfile?.email == _emailController.text &&
        userProfile?.language == _selectedLanguage) {
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
              save();
            },
            child: Text(
              'Save',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ],
      ),
      body: JuneBuilder(() => UserProfileState(),
          builder: (state) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Btextfield(
                          controller: _nameController, labelText: 'Full Name'),
                      const SizedBox(height: 16),
                      Btextfield(
                          controller: _emailController, labelText: "Email"),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedLanguage,
                        decoration: InputDecoration(
                          labelText: 'language',
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
                        // items: <String>['English 🇬🇧', 'العربية 🇲🇦', 'Français 🇫🇷'].map<DropdownMenuItem<String>>((String value) {
                        items: <String>['en', 'fr', 'ar']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          logout();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        child: const Text('Sign Out'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )),
    );
  }
}
