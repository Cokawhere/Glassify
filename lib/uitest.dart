import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class MyGlassWidget extends StatelessWidget {
  const MyGlassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 197, 176, 192),
      body: Container(
        decoration: BoxDecoration(
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
        child: Stack(
          children: [
            // الخلفية
            // Positioned.fill(
            //   child: Image.network(
            //     'https://picsum.photos/seed/bg/800/800',
            //     fit: BoxFit.cover,
            //   ),
            // ),

            // الـ LiquidGlassLayer مع كل الإعدادات
            Center(
              child: LiquidGlassLayer(
                settings: const LiquidGlassSettings(
                  thickness: 15, 
                  glassColor: Color.fromARGB(
                    22,
                    255,
                    255,
                    255,
                  ), 
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // شكل واحد
                    LiquidGlass.inLayer(
                      shape: LiquidRoundedSuperellipse(
                        borderRadius: Radius.circular(40),
                      ),
                      child: const SizedBox.square(dimension: 120),
                    ),
                    const SizedBox(height: 50),

                    // شكل تاني
                    LiquidGlass.inLayer(
                      glassContainsChild: true,
                      shape: LiquidRoundedRectangle(
                        borderRadius: Radius.circular(20),
                      ),
                      child: const SizedBox(
                        width: 300,
                        height: 80,
                        child: Center(
                          child: Text(
                            "Hello Glass",
                            style: TextStyle(fontSize: 50, color: Colors.black),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    Glassify(
                      settings: const LiquidGlassSettings(
                        thickness: 8,
                        glassColor: Color.fromARGB(51, 245, 233, 233),
                        blur: 6.0,
                      ),
                      child: const Text(
                        "Liquid Text",
                        style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 228, 14, 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LiquidGlass(
                    glassContainsChild: true,
                    shape: LiquidRoundedSuperellipse(
                      borderRadius: Radius.circular(30),
                    ),
                    child: const SizedBox(
                      width: 200,
                      height: 100,
                      child: Center(
                        child: Text(
                          "Inside Glass",
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // الطفل فوق الزجاج
                  LiquidGlass(
                    glassContainsChild: true,
                    shape: LiquidRoundedSuperellipse(
                      borderRadius: Radius.circular(30),
                    ),
                    child: const SizedBox(
                      width: 200,
                      height: 100,
                      child: Center(
                        child: Text(
                          "Above Glass",
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
