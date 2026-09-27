//B Munezero Ami christian
//2401000232
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/exercise.dart';
import '../../services/exercise_service.dart';

class CreateExerciseScreen extends StatefulWidget {
  final Exercise? exercise;

  const CreateExerciseScreen({super.key, this.exercise});

  @override
  State<CreateExerciseScreen> createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _muscleController = TextEditingController();
  final _equipmentController = TextEditingController();

  final ExerciseService _exerciseService = ExerciseService();

  String _category = 'Strength';
  String _difficulty = 'Beginner';

  bool _isSaving = false;

  bool get _isEditing => widget.exercise != null;

  @override
  void initState() {
    super.initState();

    final exercise = widget.exercise;

    if (exercise != null) {
      _nameController.text = exercise.name;
      _descriptionController.text = exercise.description;
      _muscleController.text = exercise.targetMuscle;
      _equipmentController.text = exercise.equipment;
      _category = exercise.category;
      _difficulty = exercise.difficulty;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _muscleController.dispose();
    _equipmentController.dispose();
    super.dispose();
  }

  Future<void> _saveExercise() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please sign in first.')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final exercise = Exercise(
        id: widget.exercise?.id ?? '',
        userId: widget.exercise?.userId ?? user.uid,
        name: _nameController.text.trim(),
        category: _category,
        description: _descriptionController.text.trim(),
        targetMuscle: _muscleController.text.trim(),
        difficulty: _difficulty,
        equipment: _equipmentController.text.trim(),
      );

      if (_isEditing) {
        await _exerciseService.updateExercise(exercise);
      } else {
        await _exerciseService.createExercise(exercise);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Exercise updated successfully.'
                : 'Exercise created successfully.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Failed to update exercise: $e'
                : 'Failed to create exercise: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6DDB78), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07110D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isEditing ? 'Edit Exercise' : 'Create Exercise',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    _isEditing ? Icons.edit_note : Icons.fitness_center,
                    size: 56,
                    color: const Color(0xFF6DDB78),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    _isEditing ? 'Edit Exercise' : 'Add an Exercise',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _isEditing
                        ? 'Update the exercise information.'
                        : 'Create an exercise for your fitness library.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Exercise name',
                      icon: Icons.directions_run,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter an exercise name';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _category,
                    dropdownColor: const Color(0xFF102019),
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Category',
                      icon: Icons.category,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Strength',
                        child: Text('Strength'),
                      ),
                      DropdownMenuItem(value: 'Cardio', child: Text('Cardio')),
                      DropdownMenuItem(
                        value: 'Flexibility',
                        child: Text('Flexibility'),
                      ),
                      DropdownMenuItem(
                        value: 'Balance',
                        child: Text('Balance'),
                      ),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _category = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: _inputDecoration(
                      label: 'Description',
                      icon: Icons.notes,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a description';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _muscleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Target muscle',
                      icon: Icons.accessibility_new,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter the target muscle';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _difficulty,
                    dropdownColor: const Color(0xFF102019),
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Difficulty',
                      icon: Icons.speed,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Beginner',
                        child: Text('Beginner'),
                      ),
                      DropdownMenuItem(
                        value: 'Intermediate',
                        child: Text('Intermediate'),
                      ),
                      DropdownMenuItem(
                        value: 'Advanced',
                        child: Text('Advanced'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _difficulty = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _equipmentController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Equipment',
                      icon: Icons.fitness_center,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter the equipment';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveExercise,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6DDB78),
                        foregroundColor: const Color(0xFF07110D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF07110D),
                              ),
                            )
                          : Text(
                              _isEditing ? 'Update Exercise' : 'Save Exercise',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
