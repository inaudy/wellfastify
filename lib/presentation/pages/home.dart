import 'package:wellfastify/blocs/clock/clock_bloc.dart';
import 'package:wellfastify/presentation/theme_constants.dart';
import 'package:wellfastify/presentation/widgets/circular_timer.dart';
import 'package:wellfastify/presentation/widgets/start_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    int elapsed = context.select((ClockBloc bloc) => bloc.state.elapsed);
    DateTime startTime;
    DateTime endTime;
    if (elapsed > 0) {
      startTime = DateTime.now().subtract(Duration(seconds: elapsed));
      endTime = startTime.add(Duration(
          seconds: context.select((ClockBloc bloc) => bloc.state.duration)));
    } else {
      startTime = DateTime.now();
      endTime = startTime.add(Duration(
          seconds: context.select((ClockBloc bloc) => bloc.state.duration)));
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: boxWidgetsDecoration,
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BlocBuilder<ClockBloc, ClockState>(
                            builder: (context, state) {
                              return Visibility(
                                visible: state is! ClockInitial,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Fasting',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                  ],
                                ),
                              );
                            },
                          ),

                          const CircularTimer(),
                          //plan menu buttom
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: SizedBox(
                                  width: 120,
                                  height: 48,
                                  child: BlocBuilder<ClockBloc, ClockState>(
                                    builder: (context, state) {
                                      final duration =
                                          Duration(seconds: state.duration);
                                      final hours = duration.inHours;
                                      final eatingHours = 24 - hours;
                                      return ElevatedButton(
                                        onPressed: () {
                                          context.push('/widgets/fastingplans');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.orangeAccent,
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size.zero),
                                        child: Text(
                                          '$hours:$eatingHours',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(color: Colors.white),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<ClockBloc, ClockState>(
                            builder: (context, state) {
                              return Visibility(
                                visible: state is! ClockInitial,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          // si el counter
                                          Text(
                                            'Started',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.grey),
                                          ),
                                          Text(
                                            DateFormat('EEE d, HH:mm')
                                                .format(startTime),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    color: color1,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Goal',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.grey),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                DateFormat('EEE d, HH:mm')
                                                    .format(endTime),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        color: color1,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              children: [
                                Expanded(child: StartButton()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
