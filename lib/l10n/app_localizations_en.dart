// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginWelcomeTitle => 'Welcome Back';

  @override
  String get loginSignInButton => 'Sign In';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get dashboardAppBarTitle => 'Dashboard';

  @override
  String get dashboardOpenTickets => 'Open Tickets';

  @override
  String get dashboardActiveInstallations => 'Active Installations';

  @override
  String get dashboardRepairBacklog => 'Repair Backlog';

  @override
  String get dashboardPendingDeliveries => 'Pending Deliveries';

  @override
  String get historyHubTitle => 'History Hub';
}
