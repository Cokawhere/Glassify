import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
            padding: EdgeInsets.only(right: 8, left: 8, top: 60, bottom: 80),
            child: LiquidGlass(
              settings: LiquidGlassSettings(
                thickness: 27,
                lightAngle: 90,
                lightIntensity: 1.0,
                glassColor: Color.fromARGB(13, 255, 255, 255),
              ),
              glassContainsChild: false,
              shape: LiquidRoundedSuperellipse(
                borderRadius: Radius.circular(80),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10, bottom: 50),
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
                        ),
                        child: Glassify(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 23,
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
                      const SizedBox(height: 15),

                      Liquidpasswordfield(
                        controller: passwordController,
                        label: "Password",
                      ),
                      const SizedBox(height: 15),
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
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          print("in side  on pressssed");
                          context.go("/signup");
                        },
                        child: Glassify(
                          child: Text(
                            "Don’t have an account? Sign Up",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
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
