import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:wellfastify/routes/route_name.dart';
import 'package:wellfastify/presentation/pages/fasting_plans.dart';
import 'package:wellfastify/presentation/pages/history.dart';
import 'package:wellfastify/presentation/pages/home.dart';
import 'package:wellfastify/presentation/pages/weight.dart';
import 'package:wellfastify/presentation/widgets/default_layout.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteNames.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) {
        return DefaultLayout(child: child);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: RouteNames.history,
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: RouteNames.weight,
              builder: (context, state) => const WeightPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: RouteNames.fastingplans,
              builder: (context, state) => const FastingPlansPage(),
            ),
          ],
        )
      ],
    )

    /*GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const WeightPage(),
    ),
    GoRoute(
      path: '/fasting_plans',
      builder: (context, state) => const FastingPlansPage(),
    ),*/
  ],
);
