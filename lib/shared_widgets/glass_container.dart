// lib/shared_widgets/glass_container.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget? child;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double blurStrength;
  final Color? glassColor;
  final Color? borderColor;

  const GlassContainer({
    super.key,
    this.child,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.blurStrength = 10,
    // For a light theme, we use white glass
    this.glassColor = const Color(0xFFFFFFFF),
    // and a subtle grey border
    this.borderColor = const Color(0x1A000000), // Black with 10% opacity
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: glassColor!.withOpacity(0.4), // Increase opacity slightly for light theme
            borderRadius: borderRadius ?? BorderRadius.circular(16.0),
            border: Border.all(color: borderColor!, width: 1.5),
            gradient: LinearGradient(
              colors: [
                glassColor!.withOpacity(0.5),
                glassColor!.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}