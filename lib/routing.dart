import 'package:boma/auth/auth.dart';
import 'package:boma/auth/screens/location.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouter = GoRouter(
  initialLocation: '/auth/login',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return child;
        },
        routes: [
          GoRoute(
            path: '/auth',
            builder:(context, state) {
              return const LoginScreen();
            },
            routes: [
                GoRoute(path: '/login', builder: (context, state) => const LoginScreen(),),
                GoRoute(path: '/otp', builder: (context, state)  {
                  String phoneNumber = state.extra as String;
                  return  OtpScreen(phoneNumber: phoneNumber);
                },),
                GoRoute(path: '/register', builder: (context, state) => const RegisterScreen(),),
                GoRoute(path: '/location', builder: (context, state) => const LocationScreen(),)
            ],
          ),
        ])
  ],
);
