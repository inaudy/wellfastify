import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellfastify/blocs/clock/clock_bloc.dart';
import 'package:wellfastify/models/ticker.dart';
import 'package:wellfastify/presentation/pages/fasting_plans.dart';
import 'package:wellfastify/presentation/pages/history.dart';
import 'package:wellfastify/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wellfastify/presentation/pages/weight.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
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
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClockBloc(
          ticker: const Ticker(), sharedPreferences: sharedPreferences),
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
