import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wellfastify/blocs/fasting/bloc/fasting_bloc.dart';
import 'package:wellfastify/presentation/widgets/history_chart.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    int totalFasts;
    int totalFastingTime;
    int averageFast;
    int longestFastTime;
    int maxStreak;
    int currentStreak;
    List<Map<String, dynamic>> fastingTimes;
    context.read<FastingBloc>().add(FastingLoadData());

    return Container(
      color: const Color.fromARGB(35, 88, 108, 225),
      child: BlocBuilder<FastingBloc, FastingState>(
        builder: (context, state) {
          if (state is FastingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FastingError) {
            return Center(child: Text('Failed to load data: ${state.message}'));
          }
          // Once data is loaded, calculate and display it
          if (state is FastingCrudLoaded) {
            totalFasts = state.totalFasts;
            totalFastingTime = state.totalFastingTime;
            averageFast = state.averageFast;
            longestFastTime = state.longestFastTime;
            maxStreak = state.maxStreak;
            currentStreak = state.currentStreak;
            fastingTimes = state.fastingTimes;
            return _buildStatistics(
              context,
              totalFasts,
              totalFastingTime,
              averageFast,
              longestFastTime,
              maxStreak,
              currentStreak,
              fastingTimes,
            );
          }

          // Default to an empty container if no relevant state is detected
          return Container();
        },
      ),
    );
  }

  Widget _buildStatistics(
    BuildContext context,
    int totalFasts,
    int totalFastingTime,
    int averageFast,
    int longestFastTime,
    int maxStreak,
    int currentStreak,
    List<Map<String, dynamic>> fastingTimes,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  context.read<FastingBloc>().add(FastingDeleteAll());
                  context.read<FastingBloc>().add(FastingLoadData());
                },
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    _buildStatRow(
                        context,
                        'Total fasts',
                        '$totalFasts',
                        'Total time',
                        '${(totalFastingTime ~/ 3600)}h ${(totalFastingTime % 3600) ~/ 60}m'),
                    const SizedBox(height: 16),
                    _buildStatRow(
                        context,
                        'Aver Fast',
                        '${averageFast ~/ 3600}h ${(averageFast % 3600) ~/ 60}m',
                        'Longest fast',
                        '${longestFastTime ~/ 3600}h ${(longestFastTime % 3600) ~/ 60}m'),
                    const SizedBox(height: 16),
                    _buildStatRow(context, 'Max Streak', '$maxStreak',
                        'Current Streak', '$currentStreak'),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
            height: 250,
            width: 400,
            child: BarChartSample(fastingTimes: fastingTimes)),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, String label1, String value1,
      String label2, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label1,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Text(
              value1,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ],
        ),
        const Spacer(
          flex: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              label2,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Text(
              value2,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
