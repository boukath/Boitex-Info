// lib/main.dart
import 'package:boitex_info/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:boitex_info/auth/data/auth_repository.dart';
import 'package:boitex_info/auth/data/firebase_auth_repository.dart';
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/auth/presentation/login_page.dart';
import 'package:boitex_info/core/theme.dart';
import 'package:boitex_info/features/dashboard/presentation/dashboard_page.dart';
import 'package:boitex_info/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// NOTE: I've re-added the GlobalKey for when you want to handle notification taps.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print("✅ Firebase initialized successfully!");
  } catch (e) {
    print("❌❌❌ FIREBASE INITIALIZATION FAILED: $e");
  }

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("0cd6bbc2-700d-487f-a459-50b4cc6b3652");

  OneSignal.Notifications.addClickListener((event) {
    print("Notification was tapped!");
    final notificationData = event.notification.additionalData;
    if (notificationData != null) {
      print("Data from notification: $notificationData");
      // TODO: Handle navigation here using the navigatorKey
    }
  });

  runApp(const ProviderScope(child: BoitexApp()));
}

class BoitexApp extends ConsumerWidget {
  const BoitexApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthRepository auth = FirebaseAuthRepository();
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      navigatorKey: navigatorKey, // Re-added the key
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Boitex Info',
      theme: BoitexTheme.lightTheme(),
      home: StreamBuilder<BoitexUser?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final user = snapshot.data;
          if (user == null) {
            // ADD THIS LINE: Untag the device when the user logs out.
            OneSignal.logout();
            return LoginPage(auth: auth);
          }

          // ADD THIS LINE: Tag the device with the user's unique ID when they log in.
          OneSignal.login(user.uid);
          return DashboardPage(user: user);
        },
      ),
    );
  }
}