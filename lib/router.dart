import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/webview.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import './pages/home.dart';
import './pages/page2.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) => PersistentTabView.router(
            tabs: [
              PersistentRouterTabConfig(
                item: ItemConfig(icon: const Icon(Icons.home), title: "Home"),
              ),
              PersistentRouterTabConfig(
                item: ItemConfig(
                  icon: const Icon(Icons.message),
                  title: "Messages",
                ),
              ),
              PersistentRouterTabConfig(
                item: ItemConfig(
                  icon: const Icon(Icons.settings),
                  title: "Settings",
                ),
              ),
            ],
            navBarBuilder:
                (navBarConfig) =>
                    Style1BottomNavBar(navBarConfig: navBarConfig),
            navigationShell: navigationShell,
          ),
      branches: [
        // The route branch for the 1st Tab
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: "/",
              builder:
                  (context, state) =>
                      const MyHomePage(title: 'Flutter Demo Home Page'),
              // routes: [
              //   GoRoute(
              //     path: "detail",
              //     builder:
              //         (context, state) => const MainScreen2(useRouter: true),
              //   ),
              // ],
            ),
          ],
        ),

        // The route branch for 2nd Tab
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: "/messages",
              builder: (context, state) => const Page2(),
            ),
          ],
        ),

        // The route branch for 3rd Tab
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: "/settings",
              builder:
                  (context, state) =>
                      const WebViewComponent(url: "https://www.baidu.com"),
            ),
          ],
        ),
      ],
    ),

    // ShellRoute(
    //   navigatorKey: _shellNavigatorKey,
    //   builder:
    //       (context, state, child) => Scaffold(
    //         body: child, // Dynamic content based on the active route
    //         bottomNavigationBar: BottomNavigationBar(
    //           onTap: (index) {
    //             if (index == 0) context.go('/');
    //             if (index == 1) context.go('/page2');
    //             if (index == 2) context.go('/webview');
    //           },
    //           items: const [
    //             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    //             BottomNavigationBarItem(
    //               icon: Icon(Icons.settings),
    //               label: 'Settings',
    //             ),
    //             BottomNavigationBarItem(
    //               icon: Icon(Icons.web),
    //               label: 'webview',
    //             ),
    //           ],
    //         ),
    //       ),
    //   routes: [
    //     GoRoute(
    //       path: '/',
    //       builder:
    //           (context, state) =>
    //               const MyHomePage(title: 'Flutter Demo Home Page'),
    //     ),
    //     GoRoute(path: '/page2', builder: (context, state) => const Page2()),
    //     GoRoute(
    //       path: '/webview',
    //       builder:
    //           (context, state) => const WebViewComponent(url: "https://www.baidu.com"),
    //     ),
    //   ],
    // ),
  ],
);
