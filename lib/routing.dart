import 'package:boma/auth/auth.dart';
import 'package:boma/auth/state/auth.dart';
import 'package:boma/restaurants/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouter = GoRouter(
  initialLocation: '/auth/login',
  navigatorKey: _rootNavigatorKey,
  redirect: (context, state) {
      var authState = June.getState(() => AuthState());
      if (authState.isRegistered) {
        return state.uri.toString();
      }
      else {
        if (state.uri.toString().startsWith("/auth")) {
          return state.uri.toString();
        }
         return "/auth" ;
      }
  },
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
                GoRoute(path: '/restaurants', builder: (context, state) => const HomeScreen(),)
            ],
          ),
        ])
  ],
);
