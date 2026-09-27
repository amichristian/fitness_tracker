//B Munezero Ami christian
//2401000232
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/progress_log.dart';

class ProgressLogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _progressLogs =>
      _firestore.collection('progressLogs');

  String? get _currentUserId => _auth.currentUser?.uid;

  Future<void> createProgressLog(ProgressLog progressLog) async {
    final userId = _currentUserId;

    if (userId == null) {
      throw Exception('User is not signed in.');
    }

    await _progressLogs.doc().set({...progressLog.toMap(), 'userId': userId});
  }

  Stream<List<ProgressLog>> getProgressLogs() {
    final userId = _currentUserId;

    if (userId == null) {
      return Stream.value([]);
    }

    return _progressLogs.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return ProgressLog.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<ProgressLog?> getProgressLog(String progressLogId) async {
    final doc = await _progressLogs.doc(progressLogId).get();

    if (!doc.exists) {
      return null;
    }

    return ProgressLog.fromMap(doc.id, doc.data() ?? {});
  }

  Future<void> updateProgressLog(ProgressLog progressLog) async {
    final userId = _currentUserId;

    if (userId == null) {
      throw Exception('User is not signed in.');
    }

    await _progressLogs.doc(progressLog.id).update({
      ...progressLog.toMap(),
      'userId': userId,
    });
  }

  Future<void> deleteProgressLog(String progressLogId) async {
    final userId = _currentUserId;

    if (userId == null) {
      throw Exception('User is not signed in.');
    }

    await _progressLogs.doc(progressLogId).delete();
  }
}
