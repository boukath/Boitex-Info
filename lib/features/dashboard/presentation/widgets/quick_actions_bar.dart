// lib/features/dashboard/presentation/widgets/quick_actions_bar.dart
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/dashboard/presentation/widgets/quick_action_button.dart';
import 'package:boitex_info/features/sections/installation_request_page.dart';
import 'package:boitex_info/features/sections/intervention_request_page.dart';
import 'package:boitex_info/features/sections/new_livraison_page.dart';
import 'package:boitex_info/features/sections/new_sav_ticket_page.dart';
import 'package:boitex_info/features/surveys/site_survey_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickActionsBar extends ConsumerWidget {
  const QuickActionsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- FIXED: We must properly handle the loading/error states of this provider ---
    final currentUserAsync = ref.watch(boitexUserProvider);

    return currentUserAsync.when(
      // The DATA state: User is loaded, buttons are enabled.
      data: (currentUser) => _buildButtons(context, currentUser),

      // The LOADING state: User is loading, show disabled buttons as placeholders.
      loading: () => _buildButtons(context, null, isDisabled: true),

      // The ERROR state: Something went wrong, show disabled buttons.
      error: (err, stack) => _buildButtons(context, null, isDisabled: true),
    );
  }

  // Helper method to build the row of buttons in either an enabled or disabled state.
  Widget _buildButtons(BuildContext context, BoitexUser? currentUser, {bool isDisabled = false}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          QuickActionButton(
            label: 'Intervention',
            icon: Icons.build_circle_outlined,
            onTap: isDisabled ? null : () {
              if (currentUser == null) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => InterventionRequestPage(currentUser: currentUser)));
            },
          ),
          const SizedBox(width: 12),
          QuickActionButton(
            label: 'Installation',
            icon: Icons.add_home_work_outlined,
            onTap: isDisabled ? null : () {
              if (currentUser == null) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => InstallationRequestPage(currentUser: currentUser)));
            },
          ),
          const SizedBox(width: 12),
          QuickActionButton(
            label: 'Survey',
            icon: Icons.fact_check_outlined,
            onTap: isDisabled ? null : () {
              if (currentUser == null) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => SiteSurveyFormPage(currentUser: currentUser)));
            },
          ),
          const SizedBox(width: 12),
          QuickActionButton(
            label: 'SAV',
            icon: Icons.construction_outlined,
            onTap: isDisabled ? null : () {
              if (currentUser == null) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewSavTicketPage(currentUser: currentUser)));
            },
          ),
          const SizedBox(width: 12),
          QuickActionButton(
            label: 'Livraison',
            icon: Icons.local_shipping_outlined,
            onTap: isDisabled ? null : () {
              if (currentUser == null) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewLivraisonPage(user: currentUser)));
            },
          ),
        ],
      ),
    );
  }
}