import 'package:flutter/material.dart';
class LoadingRouterObserver extends NavigatorObserver {
  final ValueNotifier<bool> isLoading;

  LoadingRouterObserver(this.isLoading);

  @override
  void didPush(Route route, Route? previousRoute) {
    isLoading.value = true;
    super.didPush(route, previousRoute);
    isLoading.value = false;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    isLoading.value = true;
    super.didPop(route, previousRoute);
    isLoading.value = false;
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    isLoading.value = true;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    isLoading.value = false;
  }
}