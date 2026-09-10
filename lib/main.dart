import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_seeker/core/app_config.dart';
import 'package:job_seeker/core/dependency_injection.dart';
import 'package:job_seeker/core/firebase/firebase_init.dart';
import 'package:job_seeker/core/firebase/firestore_seed.dart';
import 'package:job_seeker/core/provider_config/mult_provider_config.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/prsentation/auth/page/splash_page.dart';
import 'package:job_seeker/prsentation/setup/firebase_setup_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!isFirebaseConfigured) {
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseSetupPage(
        error: 'Firebase options missing. Run: flutterfire configure',
      ),
    ));
    return;
  }

  try {
    await initializeFirebase();
    AppConfig.useLocalBackend = false;
    AppConfig.firebaseInitialized = true;
    await setup();
    try {
      await FirestoreSeed.seedJobsIfEmpty();
    } catch (_) {
      // Firestore may still be empty until rules/API are ready
    }
  } catch (e) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: FirebaseSetupPage(error: e.toString()),
    ));
    return;
  }

  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      title: 'HireHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
    );
  }
}
