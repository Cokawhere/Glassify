import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/experimental.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/widgets/LiquidSnackBar.dart';
import '../../../common/widgets/liquidButton.dart';
import '../../../common/widgets/liquidPasswordfield.dart';
import '../../../common/widgets/liquidTextField.dart';
import '../controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(8.w, 100.h, 8.w, 80.h),
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
                padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 100.h),
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
                        child: Glassify(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 23.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Liquidtextfield(
                        controller: emailController,
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 15.h),

                      Liquidpasswordfield(
                        controller: passwordController,
                        label: "Password",
                      ),
                      SizedBox(height: 15.h),
                      Liquidbutton(
                        text: "Login",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final user = await ref
                                .read(authController)
                                .signin(
                                  context,
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                            if (user == null) {
                              LiquidSnackBar.show(
                                context,
                                message: "Invalid email or password",
                              );
                            }
                          } else {
                            LiquidSnackBar.show(
                              context,
                              message: "Please fill the fields correctly",
                            );
                          }
                        },
                      ),
                      SizedBox(height: 15.h),
                      InkWell(
                        onTap: () {
                          context.go("/signup");
                        },
                        child: Glassify(
                          child: Text(
                            "Don’t have an account? Sign Up",
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
