import 'package:flutter/foundation.dart';
import 'package:job_seeker/domain/entity/job_listing_entity.dart';

class JobDetailsProvider extends ChangeNotifier {
  JobDetailsProvider({required this.datasource});

  final dynamic datasource;
  JobListingEntity? _job;

  bool _isLoading = false;
  bool _isApplying = false;
  String? _error;

  JobListingEntity? get job => _job;
  bool get isLoading => _isLoading;
  bool get isApplying => _isApplying;
  String? get error => _error;

  Future<void> fetchJob(id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _job = await datasource.fethchJobById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyJobs(id, resumeUrl) async {
    _isApplying = true;
    _error = null;
    notifyListeners();

    try {
      await datasource.applyJobs(id, resumeUrl);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isApplying = false;
      notifyListeners();
    }
  }
}
