import 'package:flutter/material.dart';
import 'package:flutter_app/config/routes/route_constants.dart';
import 'package:flutter_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_app/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_app/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteConstants.login,
  debugLogDiagnostics: true,
  routes: [
    // auth
    GoRoute(
      path: RouteConstants.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteConstants.signup,
      name: 'signup',
      builder: (context, state) => const SignUpPage(),
    ),
    // home
    GoRoute(
      path: RouteConstants.home,
      name: 'home',
      builder: (context, state) => const Home(),
    ),
  ],
  // Redirect is executed before every navigation and is now used to guard
  // the app against unauthorized routes
  redirect: (BuildContext context, GoRouterState state) {
    final isAuthenticated = Supabase.instance.client.auth.currentUser != null;
    final target = state.matchedLocation;

    final isGoingToAuth =
        target.startsWith('/auth') ||
        target == RouteConstants.login ||
        target == RouteConstants.signup;

    final publicRoutes = [];
    final isPublicRoute = publicRoutes.contains(target);

    // redirect to login if unauthenticated
    if (!isAuthenticated && !isGoingToAuth && !isPublicRoute) {
      return RouteConstants.login;
    }
    // redirect to dashboard if already logged in
    if (isAuthenticated && isGoingToAuth) {
      return RouteConstants.home;
    }
    // everything else, just redirect to wanted route
    return null;
  },
);
