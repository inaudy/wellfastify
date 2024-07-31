import 'package:wellfastify/clock/clock_bloc.dart';
import 'package:wellfastify/presentation/theme_constants.dart';
import 'package:wellfastify/presentation/widgets/circular_timer.dart';
import 'package:wellfastify/presentation/widgets/start_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here based on the selected index.
  }

  @override
  Widget build(BuildContext context) {
    DateTime startTime = DateTime.now();
    DateTime endTime = startTime.add(Duration(
        seconds: context.select((ClockBloc bloc) => bloc.state.duration)));

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WELLFASTIFY',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
            SizedBox(
              width: 30,
              child: Image.asset('assets/images/fasting-icon.png'),
            )
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: boxWidgetsDecoration,
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Replace CircularTimer with a placeholder or your own implementation
                            const CircularTimer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: SizedBox(
                                    width: 50,
                                    height: 25,
                                    child: BlocBuilder<ClockBloc, ClockState>(
                                      builder: (context, state) {
                                        return ElevatedButton(
                                          onPressed: state is! ClockInitial
                                              ? null
                                              : () {
                                                  Navigator.pushNamed(
                                                      context, '/second');
                                                },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size.zero),
                                          child: Text(
                                            '${Duration(seconds: context.select((ClockBloc bloc) => bloc.state.duration)).inHours}:${24 - Duration(seconds: context.select((ClockBloc bloc) => bloc.state.duration)).inHours}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.white),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Start from',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      Text(
                                        DateFormat.Hm().format(startTime),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: color1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        'End to',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Text('(+1)',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: color1,
                                                            fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            DateFormat.Hm().format(endTime),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    color: color1,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                children: [
                                  Expanded(child: StartButton()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
