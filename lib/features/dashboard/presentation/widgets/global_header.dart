// lib/features/dashboard/presentation/widgets/global_header.dart
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/history/history_hub_page.dart';
import 'package:boitex_info/features/notifications/notifications_page.dart';
import 'package:boitex_info/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalHeader extends ConsumerWidget implements PreferredSizeWidget {
  const GlobalHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(boitexUserProvider);
    const Color iconColor = Color(0xFF34495e);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 150,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Image.asset(
          'assets/images/boitex_logo.png',
          height: kToolbarHeight - 8,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.history, color: iconColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryHubPage()),
            );
          },
        ),
        // This is the notification bell button
        IconButton(
          icon: const Badge(
            label: Text('3'),
            child: Icon(Icons.notifications_outlined, color: iconColor),
          ),
          onPressed: () {
            // This code opens the notifications page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsPage()),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: asyncUser.when(
            data: (currentUser) {
              final String fullName = currentUser?.fullName ?? '...';
              final String role = currentUser?.role.name ?? '...';
              final String initials = fullName.isNotEmpty && fullName != '...'
                  ? fullName.split(' ').map((e) => e[0]).take(2).join()
                  : '';

              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'settings') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  } else if (value == 'signOut') {
                    ref.read(firebaseAuthProvider).signOut();
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    initials.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fullName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        Text(role, style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: ListTile(leading: Icon(Icons.settings_outlined), title: Text('Settings')),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'signOut',
                    child: ListTile(leading: Icon(Icons.exit_to_app, color: Colors.red), title: Text('Sign Out', style: TextStyle(color: Colors.red))),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (err, stack) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.error_outline, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}