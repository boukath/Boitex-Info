// lib/features/dashboard/presentation/dashboard_page.dart
import 'package:boitex_info/auth/data/auth_repository.dart';
import 'package:boitex_info/auth/data/firebase_auth_repository.dart';
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/dashboard/presentation/widgets/activity_feed_widget.dart';
import 'package:boitex_info/features/dashboard/presentation/widgets/kpi_card.dart';
import 'package:boitex_info/features/dashboard/presentation/widgets/my_day_widget.dart';
import 'package:boitex_info/features/dashboard/presentation/widgets/quick_actions_bar.dart';
import 'package:boitex_info/features/dashboard/presentation/widgets/analytics_card_widget.dart';
import 'package:boitex_info/features/history/history_hub_page.dart';
import 'package:boitex_info/features/sections/delivery_list_page.dart';
import 'package:boitex_info/features/notifications/notifications_page.dart';
import 'package:boitex_info/features/sections/installation_list_page.dart';
import 'package:boitex_info/features/sections/intervention_list_page.dart';
import 'package:boitex_info/features/sections/repairs_sav_page.dart';
import 'package:boitex_info/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:boitex_info/l10n/app_localizations.dart';
import 'package:boitex_info/main.dart';

class DashboardPage extends ConsumerStatefulWidget {
  final BoitexUser user;
  const DashboardPage({super.key, required this.user});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    OneSignal.Notifications.requestPermission(true);
  }

  void _signOut() {
    final AuthRepository auth = FirebaseAuthRepository();
    auth.signOut();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final openTicketsAsyncValue = ref.watch(openTicketsCountProvider);
    final pendingDeliveriesAsyncValue = ref.watch(pendingDeliveriesCountProvider);
    final activeInstallationsAsyncValue = ref.watch(activeInstallationsCountProvider);
    final repairBacklogAsyncValue = ref.watch(repairBacklogCountProvider);

    final roleName = widget.user.role.name;
    final displayRole = roleName[0].toUpperCase() + roleName.substring(1);

    final greeting = _getGreeting();
    final firstName = widget.user.fullName.split(' ')[0];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFEAEBEE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(greeting, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                          Text(firstName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.history_outlined, color: Colors.black54),
                      tooltip: 'History',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryHubPage())),
                    ),
                    IconButton(
                      icon: const Badge(label: Text('3'), child: Icon(Icons.notifications_outlined, color: Colors.black54)),
                      tooltip: 'Notifications',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage())),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'settings') {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                        } else if (value == 'signOut') {
                          _signOut();
                        }
                      },
                      icon: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: Text(widget.user.fullName.isNotEmpty ? widget.user.fullName[0].toUpperCase() : 'U', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                      ),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          enabled: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(displayRole, style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(value: 'settings', child: ListTile(leading: Icon(Icons.settings_outlined), title: Text('Settings'))),
                        PopupMenuItem<String>(value: 'signOut', child: ListTile(leading: Icon(Icons.logout, color: Colors.red.shade600), title: Text('Sign Out', style: TextStyle(color: Colors.red.shade600)))),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 16, 16.0, 0),
                        child: QuickActionsBar(),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverGrid.count(
                        crossAxisCount: 2, // Keep it simple on mobile
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 1.0,
                        children: [
                          KpiCard(title: l10n.dashboardOpenTickets, value: openTicketsAsyncValue.when(data: (c) => c.toString(), loading: () => '...', error: (e, s) => '0'), icon: Icons.confirmation_number_outlined, color: Colors.indigo, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InterventionListPage()))),
                          KpiCard(title: l10n.dashboardActiveInstallations, value: activeInstallationsAsyncValue.when(data: (c) => c.toString(), loading: () => '...', error: (e, s) => '0'), icon: Icons.add_home_work_outlined, color: Colors.teal, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InstallationListPage()))),
                          KpiCard(title: l10n.dashboardRepairBacklog, value: repairBacklogAsyncValue.when(data: (c) => c.toString(), loading: () => '...', error: (e, s) => '0'), icon: Icons.construction_outlined, color: Colors.orange, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RepairsSavPage(user: widget.user)))),
                          KpiCard(title: l10n.dashboardPendingDeliveries, value: pendingDeliveriesAsyncValue.when(data: (c) => c.toString(), loading: () => '...', error: (e, s) => '0'), icon: Icons.local_shipping_outlined, color: Colors.blueGrey, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryListPage()))),
                        ],
                      ),
                    ),
                    // --- FIXED: Placed the widgets in a stable, vertical stack ---
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: AnalyticsCardWidget(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: MyDayWidget(),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                        child: ActivityFeedWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}