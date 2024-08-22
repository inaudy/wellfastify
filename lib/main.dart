import 'package:wellfastify/blocs/clock/bloc/clock_bloc.dart';
import 'package:wellfastify/blocs/fasting/bloc/fasting_bloc.dart';
import 'package:wellfastify/blocs/navigation/bottom_nav_cubit.dart';
import 'package:wellfastify/blocs/weight/bloc/weight_bloc.dart';
import 'package:wellfastify/blocs/weightgoal/bloc/weightgoal_bloc.dart';
import 'package:wellfastify/models/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/notification/notification.dart';
import 'package:wellfastify/router.dart';
import 'package:wellfastify/services/db_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ClockBloc(ticker: Ticker(), dbService: DBService()),
        ),
        BlocProvider(
          create: (_) => FastingBloc(dbService: DBService()),
        ),
        BlocProvider(
          create: (_) => WeightBloc(dbService: DBService()),
        ),
        BlocProvider(
          create: (_) => WeightGoalBloc(dbService: DBService()),
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
