import 'package:boma/auth/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  void signout(BuildContext context, AuthState state) async {
    await state.signOut();
    context.go('/auth/login');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
  
        body: JuneBuilder(
          () => AuthState(),
          builder: (state) => Center(
            child: Padding(
            padding:  const EdgeInsets.all(16.0),
            child:  ElevatedButton(onPressed:  () => { signout(context, state) } , child: const Text('log out')),
          )),
        ));
  }
}
