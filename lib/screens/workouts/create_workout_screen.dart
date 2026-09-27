//B Munezero Ami christian
//2401000232
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/workout.dart';
import '../../services/workout_service.dart';
import '../../widgets/mock_interstitial_ad.dart';

class CreateWorkoutScreen extends StatefulWidget {
  final Workout? workout;

  const CreateWorkoutScreen({super.key, this.workout});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();

  final WorkoutService _workoutService = WorkoutService();

  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  bool get _isEditing => widget.workout != null;

  @override
  void initState() {
    super.initState();

    final workout = widget.workout;

    if (workout != null) {
      _titleController.text = workout.title;
      _descriptionController.text = workout.description;
      _durationController.text = workout.duration.toString();
      _caloriesController.text = workout.calories.toString();
      _selectedDate = workout.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveWorkout() async {
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
      final workout = Workout(
        id: widget.workout?.id ?? '',
        userId: widget.workout?.userId ?? user.uid,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        duration: int.parse(_durationController.text.trim()),
        calories: int.parse(_caloriesController.text.trim()),
      );

      if (_isEditing) {
        await _workoutService.updateWorkout(workout);
      } else {
        await _workoutService.createWorkout(workout);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Workout updated successfully.'
                : 'Workout created successfully.',
          ),
        ),
      );

      if (!_isEditing && mounted) {
        await MockInterstitialAd.show(context);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Failed to update workout: $e'
                : 'Failed to create workout: $e',
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
          _isEditing ? 'Edit Workout' : 'Create Workout',
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
                    size: 54,
                    color: const Color(0xFF6DDB78),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    _isEditing ? 'Edit Your Workout' : 'Add a Workout',
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
                        ? 'Update your workout details and keep your records accurate.'
                        : 'Record your training session and keep track of your progress.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Workout title',
                      icon: Icons.title,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a workout title';
                      }
                      return null;
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

                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(16),
                    child: InputDecorator(
                      decoration: _inputDecoration(
                        label: 'Workout date',
                        icon: Icons.calendar_month,
                      ),
                      child: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _durationController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      label: 'Duration (minutes)',
                      icon: Icons.timer,
                    ),
                    validator: (value) {
                      final duration = int.tryParse(value ?? '');

                      if (duration == null || duration <= 0) {
                        return 'Enter a valid duration';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _caloriesController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      label: 'Calories burned',
                      icon: Icons.local_fire_department,
                    ),
                    validator: (value) {
                      final calories = int.tryParse(value ?? '');

                      if (calories == null || calories < 0) {
                        return 'Enter valid calories';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveWorkout,
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
                              _isEditing ? 'Update Workout' : 'Save Workout',
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
