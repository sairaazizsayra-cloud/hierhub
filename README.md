# HireHub – Firebase Auth + Firestore

Flutter job app using project **hirehub-app-de9ad**.

## Already done
- Flutter apps registered (Android / iOS / Web)
- `lib/firebase_options.dart` generated
- **Email/Password Authentication enabled** (`firebase deploy --only auth`)
- App code uses Firebase Auth + Firestore only

## You must do once (Firestore API)
Firestore API is not enabled yet on this Google Cloud project.

1. Open and click **Enable**:  
   https://console.cloud.google.com/apis/library/firestore.googleapis.com?project=hirehub-app-de9ad
2. Create database:  
   https://console.firebase.google.com/project/hirehub-app-de9ad/firestore  
   → **Create database** (start in test mode, or production + deploy rules)
3. Deploy rules from project root:

```bash
firebase deploy --only firestore:rules --project hirehub-app-de9ad
```

4. Restart app:

```bash
flutter run
```

On first successful Firestore connection, sample jobs seed into `JobList`.

## Auth flow
- **Register** → choose Job Seeker or Recruiter → Firebase Auth Email/Password → profile form
- **Job seeker** → browse/apply to jobs, bookmarks, job applications, chat
- **Recruiter** → post jobs, review job applicants, update hiring status, chat
- **Login** → Firebase Auth → load profile from Firestore
- **Reset password** → Firebase Auth email link

## Collections
See `FIREBASE_SETUP.md` for `profiles`, `JobList`, `applications`, `bookmarks`, `rooms`, `messages`.
