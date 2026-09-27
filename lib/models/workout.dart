//B Munezero Ami christian
//2401000232
class Workout {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime date;
  final int duration;
  final int calories;

  Workout({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.calories,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'duration': duration,
      'calories': calories,
    };
  }

  factory Workout.fromMap(String id, Map<String, dynamic> map) {
    return Workout(
      id: id,
      userId: map['userId']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      date: DateTime.parse(
        map['date']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      duration: (map['duration'] as num?)?.toInt() ?? 0,
      calories: (map['calories'] as num?)?.toInt() ?? 0,
    );
  }
}
