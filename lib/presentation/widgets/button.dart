import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/blocs/clock_bloc/clock_bloc.dart';
import 'package:wellfastify/blocs/fasting_bloc/fasting_bloc.dart';
import 'package:wellfastify/models/fasting_model.dart';
import 'package:wellfastify/core/constants/app_colors.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClockBloc, ClockState>(
      builder: (context, state) {
        Fasting fasting;
        DateTime now = DateTime.now();
        //DateTime? startTimer;
        String buttonText = 'Start';
        Function()? onPress;
        Color? backgroundColor;

        if (state is ClockInitial) {
          buttonText = 'Start';
          backgroundColor = kButtonStartColor;
          onPress = () {
            context
                .read<ClockBloc>()
                .add(StartedClock(state.duration, elapsed: 0));
          };
        }

        if (state is ClockRunning) {
          buttonText = 'Stop';
          backgroundColor = kButtonStopColor;
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
          buttonText = 'Complete';
          backgroundColor = kButtonCompleteColor;
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

        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ElevatedButton(
            onPressed: onPress,
            style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                //minimumSize: const Size.fromHeight(48),
                fixedSize: const Size(200, 40),
                backgroundColor: backgroundColor),
            child: Text(
              buttonText,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        );
      },
    );
  }
}
