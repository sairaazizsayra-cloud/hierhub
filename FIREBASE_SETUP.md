# Firebase Setup for HireHub

HireHub now uses **Firebase** (Auth, Firestore, Storage) instead of Supabase.

## 1. Create Firebase project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (e.g. `hirehub-app`)
3. Add an **Android** app with package name: `com.example.job_seeker`
4. Download `google-services.json` and place it in `android/app/`

## 2. Enable services

| Service | Action |
|---------|--------|
| **Authentication** | Enable Email/Password sign-in |
| **Cloud Firestore** | Create database (test mode for dev) |
| **Storage** | Enable default bucket |

## 3. Configure Flutter

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This updates `lib/firebase_options.dart` with your real API keys.

## 4. Firestore collections

Create these collections (same structure as the original Supabase tables):

### `profiles` (document ID = user UID)
```json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "john@example.com",
  "phone_no": "",
  "address": "",
  "date_of_birth": "01-01-1990",
  "job_profile": "Developer",
  "skills": "Flutter, Dart",
  "avatar": "",
  "resume_url": "",
  "role": "job_seeker",
  "company_name": "",
  "organisation": "",
  "location": "",
  "description": ""
}
```

### `JobList`
```json
{
  "id": 1,
  "job_title": "Flutter Developer",
  "job_desc": "Build mobile apps",
  "company_name": "Tech Co",
  "location": "Remote",
  "salary": "50000",
  "type": "Full-time",
  "level": "Mid",
  "working_model": "Remote",
  "tags": "Programmer",
  "image": "",
  "created_at": "2024-01-01",
  "recruiter_id": "<recruiter_uid>",
  "is_active": true
}
```

### `applications`
```json
{
  "usr_id": "<user_uid>",
  "job_post_id": 1,
  "resume_url": "https://...",
  "status": "applied",
  "job_title": "Flutter Developer",
  "company_name": "Tech Co",
  "image": "",
  "recruiter_id": "<recruiter_uid>",
  "applicant_name": "John Doe",
  "applicant_email": "john@example.com",
  "applicant_skills": "Flutter, Dart"
}
```

### `bookmarks`
```json
{
  "user_id": "<user_uid>",
  "job_post_id": 1
}
```

### `room`
```json
{
  "user_id": "<seeker_uid>",
  "recruiter_id": "<recruiter_uid>",
  "job_post_id": 1,
  "job_title": "Flutter Developer",
  "recuiters": {
    "id": "recruiter_uid",
    "name": "HR Manager",
    "email": "hr@company.com",
    "organisation": "Tech Co",
    "avatar": "",
    "location": "NYC",
    "description": "Hiring team"
  }
}
```

### `messages`
```json
{
  "room_id": "<room_id>",
  "sender_id": "<uid>",
  "reciever_id": "<uid>",
  "content": "Hello!",
  "created_at": "<timestamp>"
}
```

## 5. Storage rules (dev)

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 6. Firestore rules (dev)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 7. Run the app

```bash
flutter pub get
flutter run
```

Until `firebase_options.dart` has real keys, the app shows the **Firebase Setup** screen.
