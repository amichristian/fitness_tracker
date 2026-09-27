//B Munezero Ami christian
//2401000232
class Exercise {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String description;
  final String targetMuscle;
  final String difficulty;
  final String equipment;

  Exercise({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.description,
    required this.targetMuscle,
    required this.difficulty,
    required this.equipment,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'category': category,
      'description': description,
      'targetMuscle': targetMuscle,
      'difficulty': difficulty,
      'equipment': equipment,
    };
  }

  factory Exercise.fromMap(String id, Map<String, dynamic> map) {
    return Exercise(
      id: id,
      userId: map['userId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      targetMuscle: map['targetMuscle']?.toString() ?? '',
      difficulty: map['difficulty']?.toString() ?? '',
      equipment: map['equipment']?.toString() ?? '',
    );
  }
}
