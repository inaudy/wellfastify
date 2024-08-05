// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wellfastify/blocs/clock/clock_bloc.dart';

class FastingPlans extends StatelessWidget {
  FastingPlans(
      {super.key,
      required this.plan,
      required this.dificult,
      required this.background,
      required this.startsColor});
  int plan;
  int dificult;
  Color background;
  Color startsColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: BlocBuilder<ClockBloc, ClockState>(
        builder: (context, state) {
          return InkWell(
            onTap: () {
              print(plan);
              plan = Duration(hours: plan).inSeconds;
              //context.read<ClockBloc>().add(SetClock(plan, 0));
              // aqui agregar para cambiar la duracion

              if (state.elapsed > 0) {
                context.read<ClockBloc>().add(
                      ChangeDuration(plan, state.elapsed),
                    );
              } else {
                context.read<ClockBloc>().add(
                      SetClock(plan, 0),
                    );
              }
              context.go('/home');
            },
            borderRadius: BorderRadius.circular(16),
            splashColor: background.withOpacity(0.4),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: background.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ('$plan:${24 - plan}'),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.whatshot,
                              color: startsColor,
                            ),
                            Icon(
                              Icons.whatshot,
                              color: dificult > 1
                                  ? startsColor
                                  : startsColor.withOpacity(0.5),
                            ),
                            Icon(
                              Icons.whatshot,
                              color: dificult > 2
                                  ? startsColor
                                  : startsColor.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // get text from text
                          children: [
                            Text('• $plan hours fasting',
                                style: Theme.of(context).textTheme.bodyLarge!),
                          ],
                        ),
                        Row(
                          children: [
                            Text('• ${24 - plan} hours eating',
                                style: Theme.of(context).textTheme.bodyLarge!),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
