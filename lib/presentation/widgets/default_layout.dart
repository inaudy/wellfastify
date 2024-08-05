import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wellfastify/blocs/navigation/bottom_nav_cubit.dart';
import 'package:wellfastify/presentation/widgets/app_bar.dart';
import 'package:wellfastify/presentation/widgets/navigation_bar.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  const DefaultLayout({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocListener<BottomNavCubit, int>(
        listener: (context, index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/history');
              break;
            case 2:
              context.go('/weight');
              break;
          }
        },
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            final currentIndex = context.read<BottomNavCubit>().state;
            int newIndex = currentIndex;
            if (details.primaryVelocity! > 0) {
              newIndex = (currentIndex - 1).clamp(0, 2);
            } else if (details.primaryVelocity! < 0) {
              newIndex = (currentIndex + 1).clamp(0, 2);
            }
            context.read<BottomNavCubit>().changeSelectedIndex(newIndex);
          },
          child: child,
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
