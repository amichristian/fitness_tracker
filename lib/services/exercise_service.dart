//B Munezero Ami christian
//2401000232
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/exercise.dart';

class ExerciseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _exercises =>
      _firestore.collection('exercises');

  String? get _currentUserId => _auth.currentUser?.uid;

  Future<void> createExercise(Exercise exercise) async {
    final userId = _currentUserId;

    if (userId == null) {
      throw Exception('User is not signed in.');
    }

    await _exercises.doc().set({...exercise.toMap(), 'userId': userId});
  }

  Stream<List<Exercise>> getExercises() {
    final userId = _currentUserId;

    if (userId == null) {
      return Stream.value([]);
    }

    return _exercises.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return Exercise.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<Exercise?> getExercise(String exerciseId) async {
    final doc = await _exercises.doc(exerciseId).get();

    if (!doc.exists) {
      return null;
    }

    return Exercise.fromMap(doc.id, doc.data() ?? {});
  }

  Future<void> updateExercise(Exercise exercise) async {
    final userId = _currentUserId;

    if (userId == null) {
      throw Exception('User is not signed in.');
    }

    await _exercises.doc(exercise.id).update({
      ...exercise.toMap(),
      'userId': userId,
    });
  }

  Future<void> deleteExercise(String exerciseId) async {
    final userId = _currentUserId;

    if (userId == null) {
      throw Exception('User is not signed in.');
    }

    await _exercises.doc(exerciseId).delete();
  }
}
