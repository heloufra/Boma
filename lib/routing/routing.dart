import 'package:boma/address/screens/edit.dart';
import 'package:boma/auth/auth.dart';
import 'package:boma/auth/state/auth.dart';
import 'package:boma/restaurants/screens/home.dart';
import 'package:boma/routing/notifiers.dart';
import 'package:boma/routing/observer.dart';
import 'package:boma/user/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';
import '../address/screens/add.dart';
import '../address/screens/map.dart';
import '../address/types/address.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');


final godRouter = GoRouter(
  initialLocation: '/auth',
  navigatorKey: _rootNavigatorKey,
  redirect: (context, state) {
    var authState = June.getState(() => AuthState());
    if (authState.isAuthenticated) {
      return state.uri.toString();
    } else {
      if (state.uri.toString().startsWith("/auth")) {
        return state.uri.toString();
      }
      return "/auth";
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
          builder: (context, state) {
            return const LoginScreen();
          },
          routes: [
            GoRoute(
              path: 'login',
              builder: (context, state) {
                // return  ConfirmAddress(userLocation: userLocation, onConfirmAddress: (Map<String, dynamic> o) => {},); 
                return const LoginScreen();
              },
            ),
            GoRoute(
              path: 'otp',
              builder: (context, state) {
                String phoneNumber = state.extra as String;
                return OtpScreen(phoneNumber: phoneNumber);
              },
            ),
            GoRoute(
              path: 'register',
              builder: (context, state) => const RegisterScreen(),
            ),
            GoRoute(
              path: 'restaurants',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) {
              return const UserProfileScreen();
          },
           ),
        GoRoute(
          path: '/address',
          builder: (context, state) {
            return  const LocationScreen();
          },
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) {
                // return  ConfirmAddress(userLocation: userLocation, onConfirmAddress: (Map<String, dynamic> o) => {},); 
                return const LocationScreen();
              },
            ),
            GoRoute(
              path: 'confirm',
              builder: (context, state) {
                Addressconfirmation confirm = state.extra as Addressconfirmation;
                return ConfirmAddress(confirm: confirm);
              },
            ),
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                Addressconfirmation confirm = state.extra as Addressconfirmation;
                return EditAddressScreen(confirm: confirm);
              },
            ),
            GoRoute(
              path: 'restaurants',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
  observers: [LoadingRouterObserver(theIsLoading)],
);