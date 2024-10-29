import 'package:bersamapulse/screen/home_screen.dart';
import 'package:bersamapulse/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'auth_provider.dart';


class AppRouteParser extends RouteInformationParser<RouteConfiguration> {
  @override
  Future<RouteConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    return RouteConfiguration(routeInformation.location);
  }
}

class AppRouterDelegate extends RouterDelegate<RouteConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfiguration> {

  final GlobalKey<NavigatorState> navigatorKey;
  final AuthProvider authProvider;

  AppRouterDelegate(this.authProvider) : navigatorKey = GlobalKey<NavigatorState>() {
    authProvider.addListener(notifyListeners);
  }

  @override
  void dispose() {
    authProvider.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  RouteConfiguration? get currentConfiguration {
    return authProvider.isLoggedIn ? RouteConfiguration('/home') : RouteConfiguration('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (!authProvider.isLoggedIn) MaterialPage(child: LoginScreen()),
        if (authProvider.isLoggedIn) MaterialPage(child: HomeScreen()),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteConfiguration configuration) async {}
}

class RouteConfiguration {
  final String? path;
  RouteConfiguration(this.path);
}
