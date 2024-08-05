import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellfastify/blocs/clock/clock_bloc.dart';
import 'package:wellfastify/blocs/navigation/bottom_nav_cubit.dart';
import 'package:wellfastify/models/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/router.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ClockBloc(
              ticker: const Ticker(), sharedPreferences: sharedPreferences),
        ),
        BlocProvider(
          create: (_) => BottomNavCubit(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
