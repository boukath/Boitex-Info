
import 'package:flutter/material.dart';

class SectionScaffold extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final PreferredSizeWidget? tabBar;
  final List<Widget>? actions;
  final Widget body;
  final Widget? floatingActionButton;

  const SectionScaffold({
    super.key,
    this.title,
    this.titleWidget,
    this.tabBar,
    this.actions,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final Widget builtTitle = titleWidget ??
        Text(
          title ?? '',
          style: Theme.of(context).textTheme.titleLarge,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        );

    return Scaffold(
      appBar: AppBar(
        title: builtTitle,
        bottom: tabBar,
        actions: actions,
      ),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
