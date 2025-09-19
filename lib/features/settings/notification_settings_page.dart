// lib/features/settings/notification_settings_page.dart
import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // Local state for the switches.
  bool _allowNotifications = true;
  bool _newTaskAssigned = true;
  bool _statusChanged = true;
  bool _deadlineReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Allow All Notifications'),
            subtitle: Text(_allowNotifications ? 'On' : 'Off'),
            value: _allowNotifications,
            onChanged: (bool value) {
              setState(() {
                _allowNotifications = value;
                // If all notifications are turned off, disable the rest.
                if (!value) {
                  _newTaskAssigned = false;
                  _statusChanged = false;
                  _deadlineReminder = false;
                }
              });
              // TODO: Save this preference
            },
            secondary: const Icon(Icons.notifications_active_outlined),
          ),
          const Divider(height: 1),
          // These options are only enabled if the main toggle is on.
          SwitchListTile(
            title: const Text('New Task Assigned'),
            subtitle: const Text('Notify me when I get a new assignment'),
            value: _newTaskAssigned,
            onChanged: _allowNotifications
                ? (bool value) {
              setState(() {
                _newTaskAssigned = value;
              });
              // TODO: Save this preference
            }
                : null, // Disables the switch
            secondary: const Icon(Icons.assignment_ind_outlined),
          ),
          SwitchListTile(
            title: const Text('Task Status Changed'),
            subtitle: const Text('Notify me when a task status is updated'),
            value: _statusChanged,
            onChanged: _allowNotifications
                ? (bool value) {
              setState(() {
                _statusChanged = value;
              });
              // TODO: Save this preference
            }
                : null, // Disables the switch
            secondary: const Icon(Icons.sync_alt_outlined),
          ),
          SwitchListTile(
            title: const Text('Deadline Reminder'),
            subtitle: const Text('Remind me 24 hours before a deadline'),
            value: _deadlineReminder,
            onChanged: _allowNotifications
                ? (bool value) {
              setState(() {
                _deadlineReminder = value;
              });
              // TODO: Save this preference
            }
                : null, // Disables the switch
            secondary: const Icon(Icons.timer_outlined),
          ),
        ],
      ),
    );
  }
}