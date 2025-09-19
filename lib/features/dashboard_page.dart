// lib/features/dashboard_v4/dashboard_page.dart

import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/common/ui/app_background.dart';
import 'package:boitex_info/core/roles.dart';
import 'package:flutter/material.dart';

import 'widgets/my_day_view.dart';

class DashboardV4Page extends StatefulWidget {
  final BoitexUser user;
  const DashboardV4Page({super.key, required this.user});

  @override
  State<DashboardV4Page> createState() => _DashboardV4PageState();
}

class _DashboardV4PageState extends State<DashboardV4Page> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<Tab> _tabs = [const Tab(text: 'My Day')];
  late final List<Widget> _tabViews;

  @override
  void initState() {
    super.initState();

    final isManager = widget.user.role == UserRole.manager ||
        widget.user.role == UserRole.admin ||
        widget.user.role == UserRole.ceo;

    _tabViews = [
      MyDayView(user: widget.user),
    ];

    if (isManager) {
      _tabs.add(const Tab(text: 'Team Activity'));
      _tabs.add(const Tab(text: 'Reports'));
      _tabViews.add(const Center(child: Text("Team Feed View Coming Soon!")));
      _tabViews.add(const Center(child: Text("Reports View Coming Soon!")));
    }

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Image.asset('assets/images/boitex_logo.png', height: 40),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabs,
            indicatorWeight: 3.0,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _tabViews,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}