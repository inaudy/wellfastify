import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wellfastify/blocs/clock_bloc/clock_bloc.dart';
import 'package:wellfastify/cubits/customduration_cubit.dart';

class ListWheelPicker extends StatelessWidget {
  const ListWheelPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pick Hours for Fasting',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(height: 20),
                  BlocBuilder<CustomdurationCubit, int>(
                    builder: (context, selectedDuration) {
                      return ListWheelScrollView.useDelegate(
                        itemExtent: 50,
                        diameterRatio: 2.0,
                        physics: const FixedExtentScrollPhysics(),
                        perspective: 0.005,
                        onSelectedItemChanged: (int index) {
                          context
                              .read<CustomdurationCubit>()
                              .updateDuration(index + 1);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                '${index + 1} hour${index + 1 > 1 ? 's' : ''}',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: index + 1 == selectedDuration
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                            );
                          },
                          childCount: 24, // Number of hours to pick from (1-24)
                        ),
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<ClockBloc, ClockState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  final selectedDuration =
                      context.read<CustomdurationCubit>().state;
                  if (state.elapsed > 0) {
                    context.read<ClockBloc>().add(
                          ChangeDuration(
                              selectedDuration * 60 * 60, state.elapsed),
                        );
                  } else {
                    context
                        .read<ClockBloc>()
                        .add(SetClock(duration: selectedDuration * 60 * 60, 0));
                  }

                  context
                      .read<ClockBloc>()
                      .add(SetClock(duration: selectedDuration * 60 * 60, 0));
                  context.go('/');
                  //Navigator.pop(context); // Closes the modal
                },
                child: const Text('Confirm'),
              );
            },
          ),
        ],
      ),
    );
  }
}
