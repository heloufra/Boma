import 'package:boma/auth/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:june/june.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
  
        body: JuneBuilder(
          () => AuthState(),
          builder: (state) => const Center(
            child: Padding(
            padding:  EdgeInsets.all(16.0),
            child:  Text("Arwkan"),
          )),
        ));
  }
}
