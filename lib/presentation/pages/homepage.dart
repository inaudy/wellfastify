// ignore_for_file: must_be_immutable
import 'package:wellfastify/clock/clock_bloc.dart';
import 'package:wellfastify/presentation/theme_constants.dart';
import 'package:wellfastify/presentation/widgets/circular_timer.dart';
import 'package:wellfastify/presentation/widgets/start_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    DateTime startTime = DateTime.now();
    DateTime endTime = startTime.add(Duration(
        seconds: context.select((ClockBloc bloc) => bloc.state.duration)));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: boxWidgetsDecoration,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.rocket_launch_rounded,
                        size: 50, color: Colors.amber),
                  ),
                  Column(
                    children: [
                      Text(
                        'Yay, you are going to change your life!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Text('Congratulations you are doing good!'),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: boxWidgetsDecoration,
              child: SizedBox(
                height: 520,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Fasting',
                        style: Theme.of(context).textTheme.headlineLarge),
                    const CircularTimer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                            width: 50,
                            height: 25,
                            child: BlocBuilder<ClockBloc, ClockState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: state is! ClockInitial
                                      ? null
                                      : () {
                                          Navigator.pushNamed(
                                              context, '/second');
                                        },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero),
                                  child: Text(
                                    '${Duration(seconds: context.select((ClockBloc bloc) => bloc.state.duration)).inHours}:${24 - Duration(seconds: context.select((ClockBloc bloc) => bloc.state.duration)).inHours}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                'Start from',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                              Text(
                                DateFormat.Hm().format(startTime),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: color1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                'End to',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text('(+1)',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: color1,
                                                    fontSize: 12)),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat.Hm().format(endTime),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: color1,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(children: [
                        Expanded(child: StartButton()),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.bookmark,
                    color: Colors.amber,
                    size: 50,
                  ),
                  Text(
                    'Recomendations',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: boxWidgetsDecoration,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• Start slow.'),
                          Text('• Drink a lot of water.'),
                          Text('• Clearly define the reason you’re doing it.')
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
