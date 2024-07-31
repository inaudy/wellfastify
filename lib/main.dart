import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellfastify/clock/clock_bloc.dart';
import 'package:wellfastify/models/ticker.dart';
import 'package:wellfastify/presentation/pages/fastingplans.dart';
import 'package:wellfastify/presentation/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClockBloc(
          ticker: const Ticker(), sharedPreferences: sharedPreferences),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/second': (context) => const FastingPlansPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
