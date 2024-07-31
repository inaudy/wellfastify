import 'package:wellfastify/clock/clock_bloc.dart';
import 'package:wellfastify/presentation/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/presentation/widgets/circular_canvas.dart';

class CircularTimer extends StatelessWidget {
  const CircularTimer({super.key});

  @override
  Widget build(BuildContext context) {
//Elapsed timer
    final int time = context.select((ClockBloc bloc) => bloc.state.elapsed);
    final String seconds = (time % 60).toString().padLeft(2, '0');
    final String minutes =
        ((time / 60).floor() % 60).toString().padLeft(2, '0');
    final String hours = (time / 3600).floor().toString().padLeft(2, '0');

//Remaining Timer
    final int timeRemain =
        context.select((ClockBloc bloc) => bloc.state.duration) -
            context.select((ClockBloc bloc) => bloc.state.elapsed);
    final String secondsRemain = (timeRemain % 60).toString().padLeft(2, '0');
    final String minutesRemain =
        ((timeRemain / 60).floor() % 60).toString().padLeft(2, '0');
    final String hoursRemain =
        (timeRemain / 3600).floor().toString().padLeft(2, '0');

    return SizedBox(
      width: 250,
      height: 250,
      child: BlocBuilder<ClockBloc, ClockState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              /*CircularProgressIndicator(
                value: state.duration > 0
                    ? state.elapsed / state.duration
                    : 0 / 60,
                //value: 1 / 60,
                strokeWidth: 20,
                backgroundColor: Colors.orange,
                color: color1,
              ),*/
              CircularCanvas(progress: state.elapsed / state.duration),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      'Timer Elapsed',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.blueGrey),
                    ),
                  )
                ],
              ),
              Center(
                child: BlocBuilder<ClockBloc, ClockState>(
                    builder: (context, state) {
                  return Text(
                    '$hours:$minutes:$seconds',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: color1, fontWeight: FontWeight.bold),
                  );
                }),
              ),
              Padding(
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
                                .copyWith(color: Colors.blueGrey),
                          ),
                          Text(
                            '$hoursRemain:$minutesRemain:$secondsRemain',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold),
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
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    }
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
