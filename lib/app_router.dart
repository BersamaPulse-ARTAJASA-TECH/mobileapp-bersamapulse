import 'package:bersamapulse/screen/home_screen.dart';
import 'package:bersamapulse/screen/login_screen.dart';
import 'package:bersamapulse/screen/profile_screen.dart';
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

  RouteConfiguration _currentConfiguration = RouteConfiguration('/');

  AppRouterDelegate(this.authProvider) : navigatorKey = GlobalKey<NavigatorState>() {
    authProvider.addListener(notifyListeners);
  }

  @override
  void dispose() {
    authProvider.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  RouteConfiguration? get currentConfiguration => _currentConfiguration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (!authProvider.isLoggedIn)
          MaterialPage(child: LoginScreen()),

        if (authProvider.isLoggedIn)
          MaterialPage(child: HomeScreen(onProfileTap: _navigateToProfile)),

        if (_currentConfiguration.path == '/profile')
          MaterialPage(child: ProfileScreen()),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        if (_currentConfiguration.path == '/profile') {
          _currentConfiguration = RouteConfiguration('/home');
        }
        notifyListeners();
        return true;
      },
    );
  }

  void _navigateToProfile() {
    _currentConfiguration = RouteConfiguration('/profile');
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(RouteConfiguration configuration) async {
    _currentConfiguration = configuration;
  }
}

class RouteConfiguration {
  final String? path;
  RouteConfiguration(this.path);
}
