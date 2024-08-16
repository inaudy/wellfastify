import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wellfastify/blocs/weight/bloc/weight_bloc.dart';
import 'package:wellfastify/blocs/weightgoal/bloc/weightgoal_bloc.dart';
import 'package:wellfastify/models/weight_model.dart';

class WeightPage extends StatelessWidget {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<WeightBloc>().add(WeightLoadData());
    context.read<WeightGoalBloc>().add(WeightGoalLoadData());

    return Container(
      color: const Color.fromARGB(36, 63, 81, 181),
      child: _buildStatistics(context),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    final TextEditingController _weightGoalController = TextEditingController();
    final TextEditingController _weightController = TextEditingController();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
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
                    BlocBuilder<WeightBloc, WeightState>(
                      builder: (context, state) {
                        double lastWeight = 0;
                        DateTime? lastDate;
                        if (state is WeightLoaded) {
                          lastWeight = state.lastWeight;
                          lastDate = state.lastDate;
                        }
                        return _buildStatRow(
                          context,
                          'Last Weight',
                          '$lastWeight kg',
                          'Date',
                          lastDate != null
                              ? DateFormat('EEE d, HH:mm').format(lastDate)
                              : '',
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Log Weight',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                color: Colors.grey[100]),
                            child: TextFormField(
                              controller: _weightController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 10),
                                hintText: 'Weight',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              double weight =
                                  double.parse(_weightController.text);

                              context.read<WeightBloc>().add(WeightCreate(
                                  Weight(
                                      date: DateTime.now(), weight: weight)));
                              context.read<WeightBloc>().add(WeightLoadData());
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              minimumSize: const Size.fromHeight(38),
                              backgroundColor: Colors.indigo,
                            ),
                            child: Text(
                              'Log Weight',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Weight goal (kg)',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                color: Colors.grey[100]),
                            child: BlocBuilder<WeightGoalBloc, WeightGoalState>(
                              builder: (context, state) {
                                return TextFormField(
                                  controller: _weightGoalController,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(bottom: 10),
                                    hintText: 'Weight',
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              double weightGoal =
                                  double.parse(_weightGoalController.text);

                              context
                                  .read<WeightGoalBloc>()
                                  .add(WeightGoalUpdate(goal: weightGoal));

                              context
                                  .read<WeightGoalBloc>()
                                  .add(WeightGoalLoadData());
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              minimumSize: const Size.fromHeight(38),
                              backgroundColor: Colors.indigo,
                            ),
                            child: Text(
                              'Log Weight Goal',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<WeightGoalBloc, WeightGoalState>(
                      builder: (context, state) {
                        double weightGoal = 0.0;
                        if (state is WeightGoalLoaded) {
                          weightGoal = state.goal;
                        }
                        return _buildStatRow(context, 'Goal', '$weightGoal kg',
                            'Missing', '2.0 kg');
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        const Spacer(flex: 5),
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
