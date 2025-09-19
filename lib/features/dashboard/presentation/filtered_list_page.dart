// lib/features/dashboard/presentation/filtered_list_page.dart
import 'package:flutter/material.dart';

class FilteredListPage extends StatelessWidget {
  final String title;

  const FilteredListPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Showing a filtered list for:\n$title',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}