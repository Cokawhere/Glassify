import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class Liquidbutton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const Liquidbutton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassLayer(
      settings: LiquidGlassSettings(
        thickness: 35,
        glassColor: Color.fromARGB(237, 255, 255, 255),
        blur: 6.0,
      ),
      child: Container(
        child: Glassify(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 130, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
                side: BorderSide(color: Colors.black, width: 6),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
