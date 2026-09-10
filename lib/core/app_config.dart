/// HireHub uses Firebase Auth + Firestore as the backend.
class AppConfig {
  static bool useLocalBackend = false;
  static bool firebaseInitialized = false;
  static bool get isLiveFirebase => firebaseInitialized;
}
