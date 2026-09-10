import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_seeker/core/firebase/firestore_helpers.dart';
import 'package:job_seeker/domain/entity/applications_entity.dart';

class ApplicationDatasource {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  ApplicationDatasource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Map<String, dynamic> _mapDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = withDocId(doc.data(), doc.id);
    data['document_id'] = doc.id;
    return data;
  }

  Future<List<ApplicationEntity>> fetchApplications() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    final snapshot = await _db
        .collection('applications')
        .where('usr_id', isEqualTo: user.uid)
        .get();
    final apps = snapshot.docs.map((doc) {
      return ApplicationEntity.fromJson(_mapDoc(doc));
    }).toList();
    apps.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return apps;
  }

  Future<List<ApplicationEntity>> fetchApplicationsForRecruiter() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    final snapshot = await _db
        .collection('applications')
        .where('recruiter_id', isEqualTo: user.uid)
        .get();
    final apps = snapshot.docs.map((doc) {
      return ApplicationEntity.fromJson(_mapDoc(doc));
    }).toList();
    apps.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return apps;
  }

  Future<List<ApplicationEntity>> fetchApplicationsForJob(int jobId) async {
    final apps = await fetchApplicationsForRecruiter();
    return apps.where((app) => app.jobId == jobId).toList();
  }

  Future<void> updateApplicationStatus({
    required String documentId,
    required ApplicationStatus status,
  }) async {
    if (documentId.isEmpty) {
      throw Exception('Application not found');
    }
    await _db.collection('applications').doc(documentId).set(
      {'status': status.name},
      SetOptions(merge: true),
    );
  }

  Stream<List<ApplicationStatusEntity>> subscribeToApplication() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return _db
        .collection('applications')
        .where('usr_id', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = withDocId(doc.data(), doc.id);
        return ApplicationStatusEntity.fromJson(data);
      }).toList();
    });
  }
}
