import 'package:flutter/material.dart';
import 'package:job_seeker/data/datasource/application_datasource.dart';
import 'package:job_seeker/data/datasource/job_listing_datasource.dart';
import 'package:job_seeker/domain/entity/applications_entity.dart';
import 'package:job_seeker/domain/entity/job_listing_entity.dart';

class RecruiterJobsProvider extends ChangeNotifier {
  RecruiterJobsProvider({
    required this.jobDatasource,
    required this.applicationDatasource,
  });

  final JobListingDatasource jobDatasource;
  final ApplicationDatasource applicationDatasource;

  List<JobListingEntity> myJobs = [];
  List<ApplicationEntity> applicants = [];
  List<ApplicationEntity> jobApplicants = [];
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  int get openJobsCount => myJobs.where((job) => job.isActive).length;
  int get hiredCount =>
      applicants.where((app) => app.status == ApplicationStatus.hired).length;
  int get shortlistedCount => applicants
      .where((app) => app.status == ApplicationStatus.shortlisted)
      .length;

  Future<void> loadDashboard() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      myJobs = await jobDatasource.fetchJobsByRecruiter(
        jobDatasource.authUid,
      );
      applicants = await applicationDatasource.fetchApplicationsForRecruiter();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyJobs() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      myJobs = await jobDatasource.fetchJobsByRecruiter(
        jobDatasource.authUid,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchApplicants({int? jobId}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      applicants = jobId == null
          ? await applicationDatasource.fetchApplicationsForRecruiter()
          : applicants;
      jobApplicants = jobId == null
          ? applicants
          : await applicationDatasource.fetchApplicationsForJob(jobId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> postJob({
    required String jobTitle,
    required String jobDesc,
    required String companyName,
    required String location,
    required String salary,
    required String type,
    required String level,
    required String workingModel,
    required String tags,
  }) async {
    isSaving = true;
    error = null;
    notifyListeners();
    try {
      await jobDatasource.createJob(
        jobTitle: jobTitle,
        jobDesc: jobDesc,
        companyName: companyName,
        location: location,
        salary: salary,
        type: type,
        level: level,
        workingModel: workingModel,
        tags: tags,
      );
      await fetchMyJobs();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> setJobActive(JobListingEntity job, bool isActive) async {
    await jobDatasource.setJobActive(job.id, isActive);
    await fetchMyJobs();
  }

  Future<void> updateStatus(
    ApplicationEntity application,
    ApplicationStatus status,
  ) async {
    await applicationDatasource.updateApplicationStatus(
      documentId: application.documentId,
      status: status,
    );
    final index =
        applicants.indexWhere((item) => item.documentId == application.documentId);
    if (index != -1) {
      applicants[index] = applicants[index].copyWith(status: status);
    }
    final jobIndex = jobApplicants
        .indexWhere((item) => item.documentId == application.documentId);
    if (jobIndex != -1) {
      jobApplicants[jobIndex] = jobApplicants[jobIndex].copyWith(status: status);
    }
    notifyListeners();
  }
}
