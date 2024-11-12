import 'package:flutter/material.dart';

class CustomRouteObserver extends NavigatorObserver {
  String? currentRouteName;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    currentRouteName = route.settings.name ?? "Unnamed route";
    debugPrint('Current route: $currentRouteName');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    currentRouteName = previousRoute?.settings.name ?? "Unnamed route";
    debugPrint('Current route: $currentRouteName');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    currentRouteName = newRoute?.settings.name ?? "Unnamed route";
    debugPrint('Current route: $currentRouteName');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    currentRouteName = previousRoute?.settings.name ?? "Unnamed route";
    debugPrint('Current route: $currentRouteName');
  }
}
