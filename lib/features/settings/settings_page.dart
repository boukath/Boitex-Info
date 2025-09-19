// lib/features/settings/settings_page.dart
import 'package:boitex_info/features/settings/notification_settings_page.dart';
import 'package:flutter/material.dart';

// --- 1. ADD these imports for Riverpod and the localeProvider ---
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boitex_info/main.dart';

// --- 2. CONVERT to a ConsumerWidget ---
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  // --- 3. ADD WidgetRef to the build method ---
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current locale from the provider to set the dropdown's value
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        children: [
          // --- 4. ADD the new ListTile for Language Selection ---
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Language'),
            trailing: DropdownButton<Locale>(
              value: currentLocale,
              underline: const SizedBox(), // Hides the underline
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('fr'),
                  child: Text('Français'),
                ),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  // Update the language provider when a new language is selected
                  ref.read(localeProvider.notifier).state = locale;
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notification Preferences'),
            subtitle: const Text('Manage push notifications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Appearance'),
            subtitle: const Text('Switch between light and dark themes'),
            onTap: () {
              // TODO: Implement theme switching
            },
          ),
          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: const Text('Account & Security'),
            subtitle: const Text('Change password'),
            onTap: () {
              // TODO: Navigate to account settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {
              // TODO: Navigate to help page
            },
          ),
        ],
      ),
    );
  }
}