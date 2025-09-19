import 'package:flutter/material.dart';

class ResponsiveScrollContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const ResponsiveScrollContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: (padding ?? const EdgeInsets.all(16)).add(EdgeInsets.only(bottom: 24 + bottomInset)),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }
}

class ResponsiveWrapBar extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  const ResponsiveWrapBar({super.key, required this.children, this.spacing = 8, this.runSpacing = 8});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}

class HScroll extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const HScroll({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.horizontal, padding: padding, child: child);
  }
}
