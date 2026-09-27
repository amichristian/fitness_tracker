//B Munezero Ami christian
//2401000232
class ProgressLog {
  final String id;
  final String userId;
  final String workoutId;
  final String exerciseId;
  final DateTime date;
  final int sets;
  final int reps;
  final String weight;
  final String notes;

  ProgressLog({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.exerciseId,
    required this.date,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'workoutId': workoutId,
      'exerciseId': exerciseId,
      'date': date.toIso8601String(),
      'sets': sets.toString(),
      'reps': reps.toString(),
      'weight': weight,
      'notes': notes,
    };
  }

  factory ProgressLog.fromMap(String id, Map<String, dynamic> map) {
    return ProgressLog(
      id: id,
      userId: map['userId']?.toString() ?? '',
      workoutId: map['workoutId']?.toString() ?? '',
      exerciseId: map['exerciseId']?.toString() ?? '',
      date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
      sets: int.tryParse(map['sets']?.toString() ?? '') ?? 0,
      reps: int.tryParse(map['reps']?.toString() ?? '') ?? 0,
      weight: map['weight']?.toString() ?? '',
      notes: map['notes']?.toString() ?? '',
    );
  }
}
