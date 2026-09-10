import 'package:firebase_core/firebase_core.dart';
import 'package:job_seeker/firebase_options.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
bool get isFirebaseConfigured {
  final apiKey = DefaultFirebaseOptions.android.apiKey;
  return !apiKey.startsWith('REPLACE_') && apiKey.isNotEmpty;
}
