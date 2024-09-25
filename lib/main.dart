import 'package:flutter/services.dart';
import 'package:wellfastify/blocs/bloc_exports.dart';
import 'package:wellfastify/core/theme/app_theme.dart';
import 'package:wellfastify/cubits/customduration_cubit.dart';
import 'package:wellfastify/models/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/notification/notification.dart';
import 'package:wellfastify/routes/app_route.dart';
import 'package:wellfastify/services/db_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
        BlocProvider(create: (_) => CustomdurationCubit()),
      ],
      child: MaterialApp.router(
        theme: lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
