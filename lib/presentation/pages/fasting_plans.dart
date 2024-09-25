import 'package:wellfastify/presentation/widgets/fasting_options.dart';
import 'package:flutter/material.dart';
import 'package:wellfastify/presentation/widgets/listwheel_picker.dart';

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
              plan: 13,
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
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: InkWell(
                onTap: () {
                  //picker
                  _showListWheelPicker(context);
                },
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.deepPurple.withOpacity(0.4),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              'Custom Plan',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: Colors.deepOrange,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Text('Create your own fasting plan!')],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _showListWheelPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const ListWheelPicker();
      },
    );
  }
}
