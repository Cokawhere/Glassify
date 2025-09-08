import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class Liquidpasswordfield extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const Liquidpasswordfield({
    super.key,
    required this.controller,
    required this.label,
  });
  @override
  State<Liquidpasswordfield> createState() => _LiquidpasswordfieldState();
}

class _LiquidpasswordfieldState extends State<Liquidpasswordfield> {
  bool obscure = true;

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
              controller: widget.controller,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: widget.label,
                labelStyle: GoogleFonts.roboto(color: Colors.black87),
                suffixIcon: IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscure = !obscure),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
