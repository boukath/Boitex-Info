// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get loginWelcomeTitle => 'Bon retour';

  @override
  String get loginSignInButton => 'Se connecter';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginPasswordLabel => 'Mot de passe';

  @override
  String get loginForgotPassword => 'Mot de passe oublié?';

  @override
  String get dashboardAppBarTitle => 'Tableau de bord';

  @override
  String get dashboardOpenTickets => 'Tickets ouverts';

  @override
  String get dashboardActiveInstallations => 'Installations actives';

  @override
  String get dashboardRepairBacklog => 'Réparations en attente';

  @override
  String get dashboardPendingDeliveries => 'Livraisons en attente';

  @override
  String get historyHubTitle => 'Historique';
}
