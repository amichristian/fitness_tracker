//B Munezero Ami christian
//2401000232
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/exercise.dart';
import '../../models/progress_log.dart';
import '../../models/workout.dart';
import '../../services/exercise_service.dart';
import '../../services/progress_log_service.dart';
import '../../services/workout_service.dart';

class CreateProgressLogScreen extends StatefulWidget {
  final ProgressLog? progressLog;

  const CreateProgressLogScreen({super.key, this.progressLog});

  @override
  State<CreateProgressLogScreen> createState() =>
      _CreateProgressLogScreenState();
}

class _CreateProgressLogScreenState extends State<CreateProgressLogScreen> {
  final _formKey = GlobalKey<FormState>();

  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  final ProgressLogService _progressLogService = ProgressLogService();

  final WorkoutService _workoutService = WorkoutService();

  final ExerciseService _exerciseService = ExerciseService();

  List<Workout> _workouts = [];
  List<Exercise> _exercises = [];

  String? _selectedWorkoutId;
  String? _selectedExerciseId;

  DateTime _selectedDate = DateTime.now();

  bool _isLoading = true;
  bool _isSaving = false;

  bool get _isEditing => widget.progressLog != null;

  @override
  void initState() {
    super.initState();

    if (widget.progressLog != null) {
      _setsController.text = widget.progressLog!.sets.toString();

      _repsController.text = widget.progressLog!.reps.toString();

      _weightController.text = widget.progressLog!.weight;

      _notesController.text = widget.progressLog!.notes;

      _selectedWorkoutId = widget.progressLog!.workoutId;

      _selectedExerciseId = widget.progressLog!.exerciseId;

      _selectedDate = widget.progressLog!.date;
    }

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final workouts = await _workoutService.getWorkouts().first;

      final exercises = await _exerciseService.getExercises().first;

      if (!mounted) return;

      setState(() {
        _workouts = workouts;
        _exercises = exercises;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load workout and exercise data: $e')),
      );
    }
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6DDB78),
              surface: Color(0xFF102019),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected == null) return;

    setState(() {
      _selectedDate = selected;
    });
  }

  Future<void> _saveProgressLog() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedWorkoutId == null) {
      _showMessage('Please select a workout.');
      return;
    }

    if (_selectedExerciseId == null) {
      _showMessage('Please select an exercise.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final progressLog = ProgressLog(
        id: widget.progressLog?.id ?? '',
        userId: widget.progressLog?.userId ?? '',
        workoutId: _selectedWorkoutId!,
        exerciseId: _selectedExerciseId!,
        date: _selectedDate,
        sets: int.parse(_setsController.text.trim()),
        reps: int.parse(_repsController.text.trim()),
        weight: _weightController.text.trim(),
        notes: _notesController.text.trim(),
      );

      if (_isEditing) {
        await _progressLogService.updateProgressLog(progressLog);
      } else {
        await _progressLogService.createProgressLog(progressLog);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Progress log updated successfully.'
                : 'Progress log created successfully.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save progress log: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF6DDB78)),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF6DDB78)),
      ),
    );
  }

  Widget _buildWorkoutDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedWorkoutId,
      dropdownColor: const Color(0xFF102019),
      decoration: _inputDecoration(
        label: 'Workout',
        icon: Icons.fitness_center_rounded,
      ),
      style: const TextStyle(color: Colors.white),
      items: _workouts.map((workout) {
        return DropdownMenuItem<String>(
          value: workout.id,
          child: Text(workout.title, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedWorkoutId = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a workout';
        }

        return null;
      },
    );
  }

  Widget _buildExerciseDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedExerciseId,
      dropdownColor: const Color(0xFF102019),
      decoration: _inputDecoration(
        label: 'Exercise',
        icon: Icons.sports_gymnastics_rounded,
      ),
      style: const TextStyle(color: Colors.white),
      items: _exercises.map((exercise) {
        return DropdownMenuItem<String>(
          value: exercise.id,
          child: Text(exercise.name, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedExerciseId = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an exercise';
        }

        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_rounded, color: Color(0xFF6DDB78)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                '${_selectedDate.day.toString().padLeft(2, '0')}/'
                '${_selectedDate.month.toString().padLeft(2, '0')}/'
                '${_selectedDate.year}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF07110D), Color(0xFF0B1712), Color(0xFF07110D)],
            ),
          ),
        ),
        Positioned(
          top: -120,
          left: -80,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6DDB78).withOpacity(0.10),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
              child: const SizedBox(),
            ),
          ),
        ),
        Positioned(
          bottom: -120,
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1D8F4A).withOpacity(0.12),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07110D),
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6DDB78)),
                  )
                : Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.10),
                                ),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: const Icon(
                                            Icons.arrow_back_ios_new_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            _isEditing
                                                ? 'Edit Progress'
                                                : 'Log Progress',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 52),
                                      child: Text(
                                        'Track your workout performance',
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                    _buildWorkoutDropdown(),
                                    const SizedBox(height: 16),
                                    _buildExerciseDropdown(),
                                    const SizedBox(height: 16),
                                    _buildDatePicker(),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _setsController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: _inputDecoration(
                                        label: 'Sets',
                                        icon: Icons.repeat_rounded,
                                      ),
                                      validator: (value) {
                                        final number = int.tryParse(
                                          value?.trim() ?? '',
                                        );

                                        if (number == null || number <= 0) {
                                          return 'Enter a valid number of sets';
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _repsController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: _inputDecoration(
                                        label: 'Reps',
                                        icon:
                                            Icons.format_list_numbered_rounded,
                                      ),
                                      validator: (value) {
                                        final number = int.tryParse(
                                          value?.trim() ?? '',
                                        );

                                        if (number == null || number <= 0) {
                                          return 'Enter a valid number of reps';
                                        }

                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _weightController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: _inputDecoration(
                                        label: 'Weight',
                                        icon: Icons.monitor_weight_rounded,
                                        hint: 'e.g. 20 kg',
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _notesController,
                                      maxLines: 4,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: _inputDecoration(
                                        label: 'Notes',
                                        icon: Icons.notes_rounded,
                                        hint: 'How did the exercise feel?',
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: _isSaving
                                            ? null
                                            : _saveProgressLog,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF6DDB78,
                                          ),
                                          foregroundColor: const Color(
                                            0xFF07110D,
                                          ),
                                          disabledBackgroundColor:
                                              Colors.white24,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                        ),
                                        child: _isSaving
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Color(0xFF07110D),
                                                    ),
                                              )
                                            : Text(
                                                _isEditing
                                                    ? 'Update Progress'
                                                    : 'Save Progress',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
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
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
