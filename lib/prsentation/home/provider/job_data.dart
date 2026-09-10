import 'package:flutter/material.dart';

class JobData extends ChangeNotifier {
  List<String> recentJobFilters = [
    'All',
    'Programmer',
    'Designer',
    'Management',
    'Marketing',
    'Data',
    'QA',
    'HR',
  ];

  List<String> jobTypes = [
    'All',
    'Full-time',
    'Part-time',
    'Contract',
  ];

  List<String> workingModels = [
    'All',
    'Remote',
    'Hybrid',
    'On-site',
  ];

  List<String> jobLevels = [
    'All',
    'Junior',
    'Mid',
    'Senior',
  ];

  String selectedRecentJobFilter = 'All';

  void setSelectedRecentJobFilter(String filter) {
    selectedRecentJobFilter = filter;
    notifyListeners();
  }
}
