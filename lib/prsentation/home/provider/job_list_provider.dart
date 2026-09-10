import 'package:flutter/material.dart';
import 'package:job_seeker/core/job_match.dart';
import 'package:job_seeker/domain/entity/job_listing_entity.dart';
import 'package:job_seeker/domain/entity/user_entity.dart';

class JobListingProvider with ChangeNotifier {
  JobListingProvider({required this.datasource});

  final dynamic datasource;
  List<JobListingEntity> _jobs = [];
  String _searchQuery = '';
  String categoryFilter = 'All';
  String typeFilter = 'All';
  String workingModelFilter = 'All';
  String levelFilter = 'All';

  bool _isLoading = false;
  String? _error;

  List<JobListingEntity> get allJobs => _jobs;

  List<JobListingEntity> get jobs {
    return _jobs.where(_matchesFilters).toList();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  int get openJobsCount => _jobs.length;

  bool _matchesSearch(JobListingEntity job) {
    if (_searchQuery.isEmpty) return true;
    final query = _searchQuery;
    return job.jobTitle.toLowerCase().contains(query) ||
        job.companyName.toLowerCase().contains(query) ||
        job.location.toLowerCase().contains(query) ||
        job.tags.toLowerCase().contains(query) ||
        job.type.toLowerCase().contains(query) ||
        job.workingModel.toLowerCase().contains(query) ||
        job.jobDesc.toLowerCase().contains(query);
  }

  bool _matchesFilters(JobListingEntity job) {
    if (!_matchesSearch(job)) return false;
    if (categoryFilter != 'All' &&
        job.tags.toLowerCase() != categoryFilter.toLowerCase()) {
      return false;
    }
    if (typeFilter != 'All' &&
        job.type.toLowerCase() != typeFilter.toLowerCase()) {
      return false;
    }
    if (workingModelFilter != 'All' &&
        job.workingModel.toLowerCase() != workingModelFilter.toLowerCase()) {
      return false;
    }
    if (levelFilter != 'All' &&
        job.level.toLowerCase() != levelFilter.toLowerCase()) {
      return false;
    }
    return true;
  }

  List<JobListingEntity> matchedJobs(UserEntity? user) {
    return JobMatch.ranked(jobs, user);
  }

  List<JobListingEntity> similarJobs(JobListingEntity job) {
    return _jobs
        .where((item) => JobMatch.isSimilar(job, item))
        .take(4)
        .toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  void setCategoryFilter(String filter) {
    categoryFilter = filter;
    notifyListeners();
  }

  void setTypeFilter(String filter) {
    typeFilter = filter;
    notifyListeners();
  }

  void setWorkingModelFilter(String filter) {
    workingModelFilter = filter;
    notifyListeners();
  }

  void setLevelFilter(String filter) {
    levelFilter = filter;
    notifyListeners();
  }

  void clearJobFilters() {
    categoryFilter = 'All';
    typeFilter = 'All';
    workingModelFilter = 'All';
    levelFilter = 'All';
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> fetchJobs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _jobs = await datasource.fethchALLJobs();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
