import 'package:boma/routing/notifiers.dart';
import 'package:boma/routing/routing.dart';
import 'package:boma/theme/theme.dart';
import 'package:flutter/material.dart';
import 'routing/loading.dart';
void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: godRouter,
      title: 'Boma',
      theme: lightMode,
      darkTheme: darkMode,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            ValueListenableBuilder<bool>(
              valueListenable: theIsLoading,
              builder: (context, value, child) {
                return LoadingOverlay(isLoading: value);
              },
            ),
          ],
        );
      },
    );
  }
}
