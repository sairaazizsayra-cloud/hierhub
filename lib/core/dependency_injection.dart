import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:job_seeker/data/datasource/application_datasource.dart';
import 'package:job_seeker/data/datasource/bookmark_jobs_datasource.dart';
import 'package:job_seeker/data/datasource/chat_datasorce.dart';
import 'package:job_seeker/data/datasource/job_listing_datasource.dart';
import 'package:job_seeker/data/datasource/resume_service_datasource.dart';
import 'package:job_seeker/data/datasource/user_auth_datasource.dart';

final sl = GetIt.instance;

/// Firebase-only dependency injection (Auth + Firestore + Storage).
Future<void> setup() async {
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  sl.registerSingleton<JobListingDatasource>(JobListingDatasource());
  sl.registerSingleton<UserAuthDataSource>(UserAuthDataSource());
  sl.registerSingleton<ResumeServiceDatasource>(ResumeServiceDatasource());
  sl.registerSingleton<ApplicationDatasource>(ApplicationDatasource());
  sl.registerSingleton<BookmarksJobsDatasource>(BookmarksJobsDatasource());
  sl.registerSingleton<ChatDatasource>(ChatDatasource());
}

JobListingDatasource get jobListingDs => sl<JobListingDatasource>();
UserAuthDataSource get userAuthDs => sl<UserAuthDataSource>();
ResumeServiceDatasource get resumeDs => sl<ResumeServiceDatasource>();
ApplicationDatasource get applicationDs => sl<ApplicationDatasource>();
BookmarksJobsDatasource get bookmarkDs => sl<BookmarksJobsDatasource>();
ChatDatasource get chatDs => sl<ChatDatasource>();
