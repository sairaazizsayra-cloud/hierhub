import 'package:job_seeker/domain/entity/job_listing_entity.dart';
import 'package:job_seeker/domain/entity/user_entity.dart';

/// Scores how well a job matches a seeker's profile (0–100).
class JobMatch {
  static int score(JobListingEntity job, UserEntity? user) {
    if (user == null) return 0;
    final haystack = [
      job.jobTitle,
      job.jobDesc,
      job.tags,
      job.level,
      job.type,
      job.companyName,
    ].join(' ').toLowerCase();

    var points = 0;
    final skills = _tokens(user.skills);
    if (skills.isEmpty && user.jobProfile.trim().isEmpty) return 0;

    for (final skill in skills) {
      if (haystack.contains(skill)) points += 18;
    }

    final profile = user.jobProfile.trim().toLowerCase();
    if (profile.isNotEmpty) {
      if (job.jobTitle.toLowerCase().contains(profile)) points += 28;
      if (haystack.contains(profile)) points += 12;
    }

    if (job.workingModel.toLowerCase().contains('remote')) points += 6;
    return points.clamp(0, 100);
  }

  static List<JobListingEntity> ranked(
    List<JobListingEntity> jobs,
    UserEntity? user, {
    int minScore = 12,
  }) {
    final scored = jobs
        .map((job) => (job: job, score: score(job, user)))
        .where((item) => item.score >= minScore)
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    return scored.map((item) => item.job).toList();
  }

  static bool isSimilar(JobListingEntity a, JobListingEntity b) {
    if (a.id == b.id) return false;
    return a.tags.toLowerCase() == b.tags.toLowerCase() ||
        a.type.toLowerCase() == b.type.toLowerCase() ||
        a.jobTitle.toLowerCase().contains(b.jobTitle.toLowerCase().split(' ').first) ||
        a.workingModel.toLowerCase() == b.workingModel.toLowerCase();
  }

  static List<String> _tokens(String raw) {
    return raw
        .toLowerCase()
        .split(RegExp(r'[,/|]'))
        .expand((part) => part.split(' '))
        .map((token) => token.trim())
        .where((token) => token.length > 2)
        .toList();
  }
}
