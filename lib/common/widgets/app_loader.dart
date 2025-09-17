import 'package:flutter/material.dart';
import '../styles/colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.subfont,
        strokeWidth: 3,
      ),
    );
  }
}
