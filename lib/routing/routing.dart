import 'package:boma/address/screens/view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';
import 'package:boma/auth/auth.dart';
import 'package:boma/user/user.dart';
import 'package:boma/address/address.dart';
import 'package:boma/routing/notifiers.dart';
import 'package:boma/routing/observer.dart';

import '../address/screens/confirm_edit.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

CustomTransitionPage<T> buildPageWithTransition<T>(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

final godRouter = GoRouter(
  initialLocation: '/address',
  navigatorKey: _rootNavigatorKey,
  redirect: (context, state) {
    var authState = June.getState(() => AuthState());
    if (authState.isAuthenticated) {
      return state.uri.toString();
    } else {
      if (state.uri.toString().startsWith("/address")) {
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
          pageBuilder: (context, state) => buildPageWithTransition(
              context, state, const AddressManagementScreen()),
          routes: [
            GoRoute(
              path: 'login',
              pageBuilder: (context, state) =>
                  buildPageWithTransition(context, state, const LoginScreen()),
            ),
            GoRoute(
              path: 'otp',
              builder: (context, state) {
                String phoneNumber = state.extra as String;
                return OtpScreen(phoneNumber: phoneNumber);
              },
              pageBuilder: (context, state) {
                String phoneNumber = state.extra as String;
                return buildPageWithTransition(
                    context, state, OtpScreen(phoneNumber: phoneNumber));
              },
            ),
            GoRoute(
              path: 'register',
              builder: (context, state) => const RegisterScreen(),
              pageBuilder: (context, state) {
                return buildPageWithTransition(
                    context, state, const RegisterScreen());
              },
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) {
            return const UserProfileScreen();
          },
          pageBuilder: (context, state) {
            return buildPageWithTransition(
                context, state, const UserProfileScreen());
          },
        ),
        GoRoute(
          path: '/address',
          builder: (context, state) {
            return const AddressManagementScreen();
          },
          routes: [
            GoRoute(
                path: 'add',
                builder: (context, state) {
                  return const AddAddress();
                },
                routes: [
                  GoRoute(
                    path: 'confirm',
                    builder: (context, state) {
                      Addressconfirmation confirm =
                          state.extra as Addressconfirmation;
                      return ConfirmAddressAdd(addressconfirmation: confirm);
                    },
                  ),
                ]),
            GoRoute(
              path: '/edit',
              builder: (context, state) {
                Address address = state.extra as Address;
                return EditAddress(address: address);
              },
              routes: [
                GoRoute(
                  path: '/confirm',
                  builder: (context, state) {
                    Address address = state.extra as Address;
                    return ConfirmAddressEdit(address: address);
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/view-address',
              builder: (context, state) {
                final address = state.extra as Address;
                return ViewAddressScreen(address: address);
              },
            ),
          ],
        ),

      ],
    ),
  ],
  observers: [LoadingRouterObserver(theIsLoading)],
);
