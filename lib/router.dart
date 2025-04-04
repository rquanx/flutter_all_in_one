import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './pages/home.dart';
import './pages/page2.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder:
          (context, state, child) => Scaffold(
            body: child, // Dynamic content based on the active route
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                if (index == 0) context.go('/');
                if (index == 1) context.go('/page2');
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
      routes: [
        GoRoute(
          path: '/',
          builder:
              (context, state) =>
                  const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
        GoRoute(path: '/page2', builder: (context, state) => const Page2()),
      ],
    ),
  ],
);
