import 'package:wellfastify/blocs/clock/clock_bloc.dart';
import 'package:wellfastify/blocs/navigation/bottom_nav_cubit.dart';
import 'package:wellfastify/models/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/router.dart';
import 'package:wellfastify/services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ClockBloc(ticker: const Ticker(), dbService: DBService()),
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
