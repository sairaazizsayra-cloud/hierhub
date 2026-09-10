import 'package:job_seeker/core/dependency_injection.dart';
import 'package:job_seeker/prsentation/applications/provider/application_provider.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/bookmark/provider/bookmark_jobs_provider.dart';
import 'package:job_seeker/prsentation/chat/provider/chat_provider.dart';
import 'package:job_seeker/prsentation/chat/provider/message_provider.dart';
import 'package:job_seeker/prsentation/home/provider/filter_jobs_provider.dart';
import 'package:job_seeker/prsentation/home/provider/job_data.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:job_seeker/prsentation/job_details/provider/job_details_provider.dart';
import 'package:job_seeker/prsentation/job_details/provider/resume_service_provider.dart';
import 'package:job_seeker/prsentation/recruiter/provider/recruiter_jobs_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context) => JobData()),
  ChangeNotifierProvider(
    create: (context) => JobListingProvider(datasource: jobListingDs),
  ),
  ChangeNotifierProvider(
    create: (context) => JobFilterProvider(datasource: jobListingDs),
  ),
  ChangeNotifierProvider(
    create: (context) => JobDetailsProvider(datasource: jobListingDs),
  ),
  ChangeNotifierProvider(
    create: (context) => AuthProvider(dataSource: userAuthDs),
  ),
  ChangeNotifierProvider(
    create: (context) => ResumeProvider(datasource: resumeDs),
  ),
  ChangeNotifierProvider(
    create: (context) => ApplicationProvider(datasource: applicationDs),
  ),
  ChangeNotifierProvider(
    create: (context) => BookMarkJobProvider(datasource: bookmarkDs),
  ),
  ChangeNotifierProvider(
    create: (context) => ChatProvider(datasource: chatDs),
  ),
  ChangeNotifierProvider(
    create: (context) => MessageProvider(datasource: chatDs),
  ),
  ChangeNotifierProvider(
    create: (context) => RecruiterJobsProvider(
      jobDatasource: jobListingDs,
      applicationDatasource: applicationDs,
    ),
  ),
];
