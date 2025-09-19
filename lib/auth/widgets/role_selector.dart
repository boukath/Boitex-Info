import 'package:flutter/material.dart';
import '../../core/roles.dart';

class RoleSelector extends StatelessWidget {
  final UserRole? selected;
  final ValueChanged<UserRole> onChanged;
  const RoleSelector({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final role in kAllRoles)
          ChoiceChip(
            label: Text(role.label),
            selected: selected == role,
            onSelected: (_) => onChanged(role),
          ),
      ],
    );
  }
}
