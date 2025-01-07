import 'package:boma/error/error.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';
import 'package:boma/auth/auth.dart';
import 'package:boma/user/user.dart';
import 'package:boma/address/address.dart';
import 'package:boma/routing/notifiers.dart';
import 'package:boma/routing/observer.dart';

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
          pageBuilder: (context, state) =>
              buildPageWithTransition(context, state, const LoginScreen()),
          routes: [
            GoRoute(
              path: 'login',
              pageBuilder: (context, state) =>
                  buildPageWithTransition(context, state, const LoginScreen()),
            ),
            GoRoute(
              path: 'otp',
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
            path: '/settings',
            pageBuilder: (context, state) {
              return buildPageWithTransition(
                  context, state, const SettingsScreen());
            },
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) {
                  return buildPageWithTransition(
                      context, state, const UserProfileScreen());
                },
              ),
              GoRoute(
                path: '/address',
                pageBuilder: (context, state) {
                  return buildPageWithTransition(
                      context, state, const AddressManagementScreen());
                },
                routes: [
                  GoRoute(
                      path: 'add',
                      pageBuilder: (context, state) {
                        return buildPageWithTransition(
                            context, state, const AddAddress());
                      },
                      routes: [
                        GoRoute(
                          path: 'confirm',
                          pageBuilder: (context, state) {
                            Addressconfirmation confirm =
                                state.extra as Addressconfirmation;
                            return buildPageWithTransition(
                                context,
                                state,
                                ConfirmAddressAdd(
                                    addressconfirmation: confirm));
                          },
                        ),
                      ]),
                  GoRoute(
                      path: '/view-address',
                      pageBuilder: (context, state) {
                        final address = state.extra as EditAddressconfirmation;
                        return buildPageWithTransition(
                            context,
                            state,
                            ViewAddressScreen(
                                editAddressconfirmation: address));
                      },
                      routes: [
                        GoRoute(
                          path: '/edit',
                          pageBuilder: (context, state) {
                            EditAddressconfirmation address =
                                state.extra as EditAddressconfirmation;
                            return buildPageWithTransition(
                                context, state, EditAddress(data: address));
                          },
                          routes: [
                            GoRoute(
                              path: '/confirm',
                              pageBuilder: (context, state) {
                                EditAddressconfirmation address =
                                    state.extra as EditAddressconfirmation;
                                return buildPageWithTransition(context, state,
                                    ConfirmAddressEdit(data: address));
                              },
                            ),
                          ],
                        ),
                      ]),
                ],
              ),
            ]),
        GoRoute(
          path: "/error",
          pageBuilder: (context, state) {
            UndoableType undoableType = state.extra as UndoableType;
            return buildPageWithTransition(
                context,
                state,
                Undoable(
                  data: undoableType,
                ));
          },
          routes: [
            GoRoute(
              path: "undoable",
              pageBuilder: (context, state) {
                UndoableType undoableType = state.extra as UndoableType;
                return buildPageWithTransition(
                    context,
                    state,
                    Undoable(
                      data: undoableType,
                    ));
              },
            ),
          ],
        ),
      ],
    ),
  ],
  observers: [LoadingRouterObserver(theIsLoading)],
);
