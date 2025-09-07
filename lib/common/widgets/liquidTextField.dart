import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class Liquidtextfield extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const Liquidtextfield({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      settings: LiquidGlassSettings(
        thickness: 15,
        lightAngle: 80,
        // lightIntensity: 1.1,
        // lightness: 1,
        glassColor: Color.fromARGB(22, 255, 255, 255),
      ),
      glassContainsChild: false,
      shape: LiquidRoundedRectangle(borderRadius: Radius.circular(20)),
      child: SizedBox(
        width: 400,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Center(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              decoration: InputDecoration(
                hintText: label,
                labelStyle: GoogleFonts.roboto(color: AppColors.black),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
