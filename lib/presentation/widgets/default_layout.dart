import 'package:flutter/material.dart';
import 'package:wellfastify/presentation/widgets/app_bar.dart';
import 'package:wellfastify/presentation/widgets/navigation_bar.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  const DefaultLayout({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: child,
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
