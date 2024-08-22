import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wellfastify/blocs/weight/bloc/weight_bloc.dart';
import 'package:wellfastify/blocs/weightgoal/bloc/weightgoal_bloc.dart';
import 'package:wellfastify/models/weight_model.dart';
import 'package:wellfastify/presentation/widgets/weight_chart.dart';

class WeightPage extends StatelessWidget {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<WeightBloc>().add(WeightLoadData());
    context.read<WeightGoalBloc>().add(WeightGoalLoadData());

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        color: const Color.fromARGB(36, 63, 81, 181),
        child: BlocBuilder<WeightBloc, WeightState>(
          builder: (context, weightState) {
            return BlocBuilder<WeightGoalBloc, WeightGoalState>(
              builder: (context, weigthGoalState) {
                if (weightState is WeightLoading ||
                    weigthGoalState is WeightGoalLoading) {
                  return _buildStatistics(context,
                      weightList: List.empty(), weightGoal: 0);
                } else if (weightState is WeightLoaded &&
                    weigthGoalState is WeightGoalLoaded) {
                  return _buildStatistics(
                    context,
                    weightList: weightState.weights,
                    weightGoal: weigthGoalState.goal,
                  );
                } else if (weightState is WeightError ||
                    weigthGoalState is WeightGoalError) {
                  return const Center(
                    child: Text('Error loading data.'),
                  );
                }
                return const Center(child: Text('No data available.'));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context,
      {required List<Weight> weightList, required weightGoal}) {
    final TextEditingController weightGoalController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    context.read<WeightBloc>().add(WeightDeleteAll());
                    context
                        .read<WeightGoalBloc>()
                        .add(WeightGoalUpdate(goal: 0));
                  },
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
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
                                : 'No data',
                          );
                        },
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
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 100,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  color: Colors.grey[100]),
                              child: TextFormField(
                                controller: weightController,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
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
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                double weight =
                                    double.parse(weightController.text);

                                context.read<WeightBloc>().add(WeightCreate(
                                    Weight(
                                        date: DateTime.now(), weight: weight)));
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                minimumSize: const Size.fromHeight(10),
                                backgroundColor: Colors.indigo,
                              ),
                              child: Text(
                                'Log Weight',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 100,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  color: Colors.grey[100]),
                              child:
                                  BlocBuilder<WeightGoalBloc, WeightGoalState>(
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: weightGoalController,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(bottom: 10),
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
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                double weightGoal =
                                    double.parse(weightGoalController.text);

                                context
                                    .read<WeightGoalBloc>()
                                    .add(WeightGoalUpdate(goal: weightGoal));
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                minimumSize: const Size.fromHeight(30),
                                backgroundColor: Colors.indigo,
                              ),
                              child: Text(
                                'Log Weight Goal',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<WeightGoalBloc, WeightGoalState>(
                        builder: (context, state) {
                          double weightGoal = 0.0;
                          if (state is WeightGoalLoaded) {
                            weightGoal = state.goal;
                          }
                          return _buildStatRow(context, 'Goal',
                              '$weightGoal kg', 'Missing', '2.0 kg');
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 200,
                    child: BlocBuilder<WeightBloc, WeightState>(
                      builder: (context, state) {
                        if (state is WeightLoaded) {
                          List<Weight> weightList = state.weights;
                          return DynamicWeightChart(weightData: weightList);
                        } else {
                          return const Text('no data to show');
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
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
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
            ),
            Text(
              value1,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.indigo,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              label2,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            Text(
              value2,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.indigo,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}
