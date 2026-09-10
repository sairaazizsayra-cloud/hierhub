class UserRole {
  static const jobSeeker = 'job_seeker';
  static const recruiter = 'recruiter';

  static bool isRecruiter(String? role) => role == recruiter;
}
