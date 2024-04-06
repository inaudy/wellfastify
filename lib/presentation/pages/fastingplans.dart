import 'package:wellfastify/presentation/widgets/fasting_options.dart';
import 'package:flutter/material.dart';

class FastingPlansPage extends StatelessWidget {
  const FastingPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose a plan to start fasting!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            FastingPlans(
              dificult: 1,
              plan: 14,
              background: Colors.indigo,
              startsColor: Colors.blue,
            ),
            FastingPlans(
              dificult: 1,
              plan: 16,
              background: Colors.orange,
              startsColor: Colors.indigo,
            ),
            FastingPlans(
              dificult: 2,
              plan: 18,
              background: Colors.blueGrey,
              startsColor: Colors.redAccent,
            ),
            FastingPlans(
              dificult: 3,
              plan: 20,
              background: Colors.green,
              startsColor: Colors.red,
            ),
          ]),
        ),
      ),
    );
  }
}
