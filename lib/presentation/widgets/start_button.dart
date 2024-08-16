import 'package:wellfastify/blocs/clock/bloc/clock_bloc.dart';
import 'package:wellfastify/presentation/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockBloc, ClockState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            if (state is ClockInitial) {
              context
                  .read<ClockBloc>()
                  .add(StartedClock(state.duration, elapsed: 0));
            } else if (state is ClockRunning) {
              context.read<ClockBloc>().add(ResetClock(state.duration));
            } else if (state is ClockCompleted) {
              context.read<ClockBloc>().add(ResetClock(state.duration));
              // Do nothing or handle completed state if needed
            }
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  side: state is ClockInitial
                      ? BorderSide.none
                      : const BorderSide(color: Colors.deepOrange, width: 2)),
              minimumSize: const Size.fromHeight(48),
              backgroundColor: state is ClockInitial ? color1 : Colors.red),
          child: Text(
            state is ClockInitial ? 'START' : 'STOP',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        );
      },
    );
  }
}
