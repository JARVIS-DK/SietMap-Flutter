import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  GradientText(this.text, {required this.fontSize, required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Outer text with gradient border
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.green, Colors.grey, Colors.yellowAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            text,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2, // Border thickness
              ),
            ),
          ),
        ),
        // Inner black text
        Text(
          text,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black, // Inner text color
            ),
          ),
        ),
      ],
    );
  }
}
