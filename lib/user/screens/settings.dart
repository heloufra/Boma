import 'dart:async';
import 'package:boma/address/state/address.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';

import '../state/state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const maxSeconds = 4;
  int secondsRemaining = maxSeconds;
  Timer? timer;
  bool error = false;
  String errorMsg = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = June.getState(() => AddressState());
      _getAddresses(state);

      var userState = June.getState(() => UserProfileState());
      _getProfile(userState);
    });
  }

  void _getAddresses(AddressState state) async {
    await state.fetchAddresses();
  }

  void _getProfile(UserProfileState state) async {
    await state.getUserProfile();
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

   void _showCustomFullDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to sign out?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      logout(); // Perform sign out
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          "Profile",
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: JuneBuilder(() => UserProfileState(), builder: (state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isError) {
            return Center(
                child: Text(state.errorMessage ?? "Error loading addresses"));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  state.user?.name ?? "",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.user?.email ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.primary.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                Divider(color: theme.colorScheme.primary.withOpacity(0.2)),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    "Profile Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: theme.colorScheme.primary,
                  ),
                  onTap: () => context.go('/settings/profile'),
                ),
                ListTile(
                  title: Text(
                    "Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: theme.colorScheme.primary,
                  ),
                  onTap: () => context.go('/settings/address'),
                ),
                const SizedBox(height: 40,),
                ElevatedButton(
                  onPressed: () => _showCustomFullDialog(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
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
            );
          }
        }),
      ),
    );
  }
}
