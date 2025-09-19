import 'package:flutter/material.dart';

class AnimatedGlowCard extends StatefulWidget {
  final Widget child;
  final String level;

  const AnimatedGlowCard({super.key, required this.child, required this.level});

  @override
  State<AnimatedGlowCard> createState() => _AnimatedGlowCardState();
}

class _AnimatedGlowCardState extends State<AnimatedGlowCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // How long one pulse takes
    );

    // Determine the glow color based on the intervention level
    final Color glowColor;
    switch (widget.level) {
      case 'Red':
        glowColor = Colors.red.withOpacity(0.6);
        break;
      case 'Yellow':
        glowColor = Colors.yellow.withOpacity(0.6);
        break;
      case 'Green':
        glowColor = Colors.green.withOpacity(0.5);
        break;
      default:
        glowColor = Colors.transparent; // No glow for other levels
    }

    // Create a Tween that animates from transparent to the glow color
    _glowAnimation = ColorTween(
      begin: Colors.transparent,
      end: glowColor,
    ).animate(_controller);

    // If there's a glow color, make the animation repeat back and forth
    if (glowColor != Colors.transparent) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder listens to the controller and rebuilds the widget on every tick
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), // Match the card's radius
            boxShadow: [
              BoxShadow(
                color: _glowAnimation.value ?? Colors.transparent,
                blurRadius: 12.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}