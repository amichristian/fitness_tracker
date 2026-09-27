//B Munezero Ami christian
//2401000232
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/workout.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _workouts {
    return _firestore.collection('workouts');
  }

  String? get _currentUserId {
    return _auth.currentUser?.uid;
  }

  Future<void> createWorkout(Workout workout) async {
    final userId = _currentUserId;

    if (userId == null) {
      throw Exception('User is not signed in.');
    }

    await _workouts.add(workout.toMap());
  }

  Stream<List<Workout>> getWorkouts() {
    final userId = _currentUserId;

    print('CURRENT USER ID: $userId');

    if (userId == null) {
      return Stream.value([]);
    }

    return _workouts
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          print('WORKOUTS FOUND: ${snapshot.docs.length}');

          return snapshot.docs.map((doc) {
            print('WORKOUT ID: ${doc.id}');
            print('WORKOUT DATA: ${doc.data()}');

            return Workout.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  Future<Workout?> getWorkout(String workoutId) async {
    final document = await _workouts.doc(workoutId).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return Workout.fromMap(document.id, document.data()!);
  }

  Future<void> updateWorkout(Workout workout) async {
    final userId = _currentUserId;

    if (userId == null) {
      throw Exception('User is not signed in.');
    }

    await _workouts.doc(workout.id).update(workout.toMap());
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _workouts.doc(workoutId).delete();
  }
}
