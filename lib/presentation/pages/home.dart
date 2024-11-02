import 'package:wellfastify/blocs/bloc_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:wellfastify/core/constants/app_colors.dart';
import 'package:wellfastify/presentation/widgets/button.dart';
import 'package:wellfastify/presentation/widgets/circular_timer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final int timeRemain =
        context.select((ClockBloc bloc) => bloc.state.duration) -
            context.select((ClockBloc bloc) => bloc.state.elapsed);
    final String secondsRemain = (timeRemain % 60).toString().padLeft(2, '0');
    final String minutesRemain =
        ((timeRemain / 60).floor() % 60).toString().padLeft(2, '0');
    final String hoursRemain =
        (timeRemain / 3600).floor().toString().padLeft(2, '0');

    //load the elapsed and duration
    int elapsed = context.select((ClockBloc bloc) => bloc.state.elapsed);
    int duration = context.select((ClockBloc bloc) => bloc.state.duration);
    DateTime startTime;
    DateTime endTime;

    //check if there is a timer active
    if (elapsed > 0) {
      startTime = DateTime.now().subtract(Duration(seconds: elapsed));
      endTime = startTime.add(Duration(seconds: duration));
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
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // if is not a timer running hide started and end time
                          //_buildFastingHeader(context),
                          // Timer Widget
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).width,
                            width: MediaQuery.sizeOf(context).width,
                            child: Stack(children: [
                              Positioned(
                                  top: 20,
                                  right: 0,
                                  child: _buildPlansButton(context)),
                              Positioned.fill(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: CircularTimer(context: context))),
                            ]),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: BlocBuilder<ClockBloc, ClockState>(
                              builder: (context, state) {
                                if (timeRemain > 0) {
                                  return Column(
                                    children: [
                                      Text('Remaining',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: const Color(0xffEDF0F2)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Text(
                                                hoursRemain,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(
                                                        color: const Color(
                                                            0xffFA6161),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                //.copyWith(color: color1, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: const Color(0xffEDF0F2)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Text(
                                                minutesRemain,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(
                                                        color: const Color(
                                                            0xffFA6161),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                //.copyWith(color: color1, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: const Color(0xffEDF0F2)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Text(
                                                secondsRemain,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(
                                                        color: const Color(
                                                            0xffFA6161),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                //.copyWith(color: color1, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Completed',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),

                          //Timer start and end textbox
                          _buildStartEndTime(context, startTime, endTime),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Start/ stop timer
                              Center(child: StartButton()),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          )
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

  Widget _buildStartEndTime(
      BuildContext context, DateTime startTime, DateTime endTime) {
    return BlocBuilder<ClockBloc, ClockState>(
      builder: (context, state) {
        return Visibility(
          visible: state is! ClockInitial,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text('Started',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      DateFormat('EEE d, HH:mm').format(startTime),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'Goal',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('EEE d, HH:mm').format(endTime),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 18),
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
    );
  }

  Widget _buildPlansButton(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child:
                Text('Plans', style: Theme.of(context).textTheme.bodyMedium)),
        SizedBox(
          width: 50,
          height: 50,

          // get selected plan to the ElevatedButton
          child: BlocBuilder<ClockBloc, ClockState>(
            builder: (context, state) {
              // convert the seconds to hours
              final duration = Duration(seconds: state.duration);
              final hours = duration.inHours;

              //push the fasting plan page
              return ElevatedButton(
                onPressed: () {
                  context.push('/widgets/fastingplans');
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: kButtonPlansColor,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero),
                child: Text(
                  hours < 24 ? '$hours' : '$hours',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
