import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/graphx.dart';
import 'package:flutter_application_1/pages/counter.dart';
import 'package:flutter_application_1/pages/scroll.dart';
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
                  icon: const Icon(Icons.draw_sharp),
                  title: "Graphx",
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
              routes: [
                GoRoute(
                  path: "counter",
                  builder:
                      (context, state) => const CounterPage(title: 'counter'),
                ),
                GoRoute(
                  path: "scroll",
                  builder:
                      (context, state) => const ScrollPage(title: 'scroll'),
                ),
              ],
            ),
          ],
        ),

        // The route branch for 2nd Tab
        // StatefulShellBranch(
        //   routes: <RouteBase>[
        //     GoRoute(
        //       path: "/messages",
        //       builder: (context, state) => const Page2(),
        //     ),
        //   ],
        // ),

        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: "/graphx",
              builder: (context, state) => const Graphx(),
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
                  // for localhost
                  //  const WebViewComponent(url: "http://10.0.2.2:5500/test/test.html"),
                  const WebViewComponent(url: "https://www.baidu.com"),
            ),
          ],
        ),
      ],
    ),
  ],
);
