import 'package:wellfastify/blocs/clock/bloc/clock_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/blocs/fasting/bloc/fasting_bloc.dart';
import 'package:wellfastify/models/fasting_model.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockBloc, ClockState>(
      builder: (context, state) {
        Fasting fasting;
        DateTime now = DateTime.now();
        DateTime? startTimer;
        String buttonText = 'Start';
        Function()? onPress;
        Color? backgroundColor;

        if (state is ClockInitial) {
          buttonText = 'START';
          backgroundColor = Colors.indigo;
          onPress = () {
            context
                .read<ClockBloc>()
                .add(StartedClock(state.duration, elapsed: 0));
          };
        }

        if (state is ClockRunning) {
          buttonText = 'STOP';
          backgroundColor = Colors.red;
          onPress = () {
            if (state.startTimer != null) {
              Duration fastingDuration = now.difference(state.startTimer!);
              fasting = Fasting(
                startTime: state.startTimer!,
                endTime: now,
                fastingHours: fastingDuration.inSeconds,
                date: DateTime.now(),
              );
              context.read<FastingBloc>().add(FastingCreate(fasting));
            }
            context.read<ClockBloc>().add(ResetClock(state.duration));
          };
        }

        if (state is ClockCompleted) {
          buttonText = 'COMPLETE';
          backgroundColor = Colors.indigo;
          onPress = () {
            if (state.startTimer != null) {
              Duration fastingDuration = now.difference(startTimer!);
              fasting = Fasting(
                startTime: state.startTimer!,
                endTime: now,
                fastingHours: fastingDuration.inSeconds,
                date: DateTime.now(),
              );
              context.read<FastingBloc>().add(FastingCreate(fasting));
            }
            context.read<ClockBloc>().add(ResetClock(state.duration));
          };
        }

        return ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              minimumSize: const Size.fromHeight(48),
              backgroundColor: backgroundColor),
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        );
      },
    );
  }
}
