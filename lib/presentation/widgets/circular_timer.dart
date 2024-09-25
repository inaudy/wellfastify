import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/blocs/clock_bloc/clock_bloc.dart';
import 'package:wellfastify/presentation/widgets/circular_canvas.dart';

class CircularTimer extends StatelessWidget {
  const CircularTimer({super.key, required BuildContext context});

  @override
  Widget build(BuildContext context) {
//Elapsed timer
    final int time = context.select((ClockBloc bloc) => bloc.state.elapsed);
    final String seconds = (time % 60).toString().padLeft(2, '0');
    final String minutes =
        ((time / 60).floor() % 60).toString().padLeft(2, '0');
    final String hours = (time / 3600).floor().toString().padLeft(2, '0');

    return SizedBox(
      width: 250,
      height: 250,
      child: BlocBuilder<ClockBloc, ClockState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Text('Timer Elapsed',
                        style: Theme.of(context).textTheme.bodyMedium!),
                  )
                ],
              ),
              if (state is ClockCompleted)
                const CircularCanvas(progress: 1)
              else
                CircularCanvas(progress: state.elapsed / state.duration),
              BlocBuilder<ClockBloc, ClockState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          '$hours:$minutes:$seconds',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                          //.copyWith(color: color1, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              ),

              /*Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: BlocBuilder<ClockBloc, ClockState>(
                  builder: (context, state) {
                    if (timeRemain > 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Remaining',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Color(0xff1C1C21)),
                          ),
                          Text(
                            '$hoursRemain:$minutesRemain:$secondsRemain',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: kButtonStopColor,
                                  fontWeight: FontWeight.bold,
                                ),
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
              )*/
            ],
          );
        },
      ),
    );
  }
}
