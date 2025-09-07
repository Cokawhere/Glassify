import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../common/styles/colors.dart';
import 'controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.pink,
              AppColors.white,
              AppColors.pink,
              AppColors.white,
            ],
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'إنشاء حساب',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'الإيميل',
                      labelStyle: GoogleFonts.roboto(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      labelStyle: GoogleFonts.roboto(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: displayNameController,
                    decoration: InputDecoration(
                      labelText: 'اسم المستخدم',
                      labelStyle: GoogleFonts.roboto(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'رابط صورة البروفايل (اختياري)',
                      labelStyle: GoogleFonts.roboto(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(authController)
                          .signup(
                            context,
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            displayName: displayNameController.text.trim(),
                            imageUrl: imageUrlController.text.trim().isEmpty
                                ? null
                                : imageUrlController.text.trim(),
                          );
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
                      'إنشاء حساب',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () => context.go('/login'),
                    child: Text(
                      "login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
