import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../common/styles/colors.dart';
import '../Auth/controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStream = ref.watch(userStreamProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.pink,
              AppColors.white,
              AppColors.pink,
              AppColors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: LiquidGlassLayer(
            settings: const LiquidGlassSettings(
              thickness: 8,
              glassColor: Color.fromARGB(51, 245, 233, 233),
              blur: 6.0,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 300,
              child: userStream.when(
                data: (user) {
                  if (user == null) {
                    return Text(
                      'غير مسجل دخول',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'مرحبًا ${user.name}',
                        style: GoogleFonts.roboto(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (user.imageUrl != null && user.imageUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            user.imageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.black,
                                ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await ref.read(authController).signout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'تسجيل الخروج',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(
                  'خطأ: $e',
                  style: GoogleFonts.roboto(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
