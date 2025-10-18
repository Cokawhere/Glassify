import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/liquidPasswordfield.dart'
    show Liquidpasswordfield;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/experimental.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../../common/styles/colors.dart';
import '../../../common/widgets/LiquidSnackBar.dart';
import '../../../common/widgets/liquidButton.dart';
import '../../../common/widgets/liquidTextField.dart';
import '../controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    imageUrlController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.pink,
              AppColors.white,
              AppColors.pink,
              AppColors.pink,
              AppColors.pink,
            ],
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 50.h),
            child: LiquidGlass(
              settings: LiquidGlassSettings(
                thickness: 27,
                lightAngle: 90,
                lightIntensity: 1.0,

                glassColor: Color.fromARGB(13, 255, 255, 255),
              ),
              glassContainsChild: false,
              shape: LiquidRoundedSuperellipse(
                borderRadius: Radius.circular(80.r),
              ),

              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 50.h),
                child: Form(
                  key: _formKey,

                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                          left: 10,
                          top: 30,
                          bottom: 20,
                        ).r,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Glassify(
                              child: Text(
                                'Welcome',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Liquidtextfield(
                        controller: emailController,
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      Liquidtextfield(
                        controller: nameController,
                        label: "Name",
                        validator: (val) => null,
                      ),
                      SizedBox(height: 15.h),

                      Liquidtextfield(
                        controller: imageUrlController,
                        label: "Profile Image (optional)",
                      ),
                      SizedBox(height: 15.h),

                      Liquidpasswordfield(
                        controller: passwordController,
                        label: "Password",
                      ),
                      SizedBox(height: 15.h),

                      Liquidpasswordfield(
                        controller: confirmPasswordController,
                        label: "Confirm Password",
                      ),
                      SizedBox(height: 15.h),

                      Liquidbutton(
                        text: "Sign Up",
                        onPressed: () async {
                          final email = emailController.text.trim();
                          final name = nameController.text.trim();
                          final password = passwordController.text.trim();
                          final confirmPassword = confirmPasswordController.text
                              .trim();

                          if (email.isEmpty) {
                            LiquidSnackBar.show(
                              context,
                              message: "Email is required",
                            );
                            return;
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(email)) {
                            LiquidSnackBar.show(
                              context,
                              message: "Enter a valid email",
                            );
                            return;
                          }

                          if (name.isEmpty) {
                            LiquidSnackBar.show(
                              context,
                              message: "Name is required",
                            );
                            return;
                          }
                          if (name.length < 3) {
                            LiquidSnackBar.show(
                              context,
                              message: "Name must be at least 3 characters",
                            );
                            return;
                          }

                          if (password.isEmpty) {
                            LiquidSnackBar.show(
                              context,
                              message: "Password is required",
                            );
                            return;
                          }
                          if (password.length < 6) {
                            LiquidSnackBar.show(
                              context,
                              message: "Password must be at least 6 characters",
                            );
                            return;
                          }

                          if (confirmPassword.isEmpty) {
                            LiquidSnackBar.show(
                              context,
                              message: "Please confirm your password",
                            );
                            return;
                          }
                          if (password != confirmPassword) {
                            LiquidSnackBar.show(
                              context,
                              message: "Passwords do not match",
                            );
                            return;
                          }

                          await ref
                              .read(authController)
                              .signup(
                                context,
                                email: email,
                                password: password,
                                displayName: name,
                                imageUrl: imageUrlController.text.trim().isEmpty
                                    ? null
                                    : imageUrlController.text.trim(),
                              );
                        },
                      ),
                      SizedBox(height: 15.h),
                      InkWell(
                        onTap: () => context.go("/login"),
                        child: Glassify(
                          child: Text(
                            "Already have an account? Login",
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
