//B Munezero Ami christian
//2401000232
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/progress_log.dart';
import '../../services/exercise_service.dart';
import '../../services/progress_log_service.dart';
import '../../services/workout_service.dart';
import 'create_progress_log_screen.dart';

class ProgressLogDetailsScreen extends StatefulWidget {
  final ProgressLog progressLog;

  const ProgressLogDetailsScreen({super.key, required this.progressLog});

  @override
  State<ProgressLogDetailsScreen> createState() =>
      _ProgressLogDetailsScreenState();
}

class _ProgressLogDetailsScreenState extends State<ProgressLogDetailsScreen> {
  late ProgressLog _progressLog;

  final ProgressLogService _progressLogService = ProgressLogService();

  final WorkoutService _workoutService = WorkoutService();
  final ExerciseService _exerciseService = ExerciseService();

  String _workoutName = 'Workout';
  String _exerciseName = 'Exercise';

  bool _isLoadingNames = true;

  @override
  void initState() {
    super.initState();

    _progressLog = widget.progressLog;

    _loadNames();
  }

  Future<void> _loadNames() async {
    try {
      final workout = await _workoutService.getWorkout(_progressLog.workoutId);

      final exercise = await _exerciseService.getExercise(
        _progressLog.exerciseId,
      );

      if (!mounted) return;

      setState(() {
        _workoutName = workout?.title ?? 'Workout';
        _exerciseName = exercise?.name ?? 'Exercise';
        _isLoadingNames = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingNames = false;
      });
    }
  }

  Future<void> _editProgress() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateProgressLogScreen(progressLog: _progressLog),
      ),
    );

    if (updated != true) return;

    final refreshed = await _progressLogService.getProgressLog(_progressLog.id);

    if (!mounted) return;

    if (refreshed != null) {
      setState(() {
        _progressLog = refreshed;
      });

      await _loadNames();
    }
  }

  Future<void> _deleteProgress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF102019),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Delete Progress Log?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this progress log? '
            'This action cannot be undone.',
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _progressLogService.deleteProgressLog(_progressLog.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress log deleted successfully.')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete progress log: $e')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.055),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF6DDB78), size: 27),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.045),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF6DDB78).withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF6DDB78), size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6DDB78).withOpacity(0.09),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
              child: const SizedBox(),
            ),
          ),
        ),
        Positioned(
          bottom: -140,
          left: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1D8F4A).withOpacity(0.10),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 85, sigmaY: 85),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Text(
                              'Progress Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.055),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.09),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 68,
                                      height: 68,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6DDB78)
                                            .withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.trending_up_rounded,
                                        color: Color(0xFF6DDB78),
                                        size: 36,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _isLoadingNames
                                                ? 'Loading...'
                                                : _exerciseName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            _workoutName,
                                            style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 26),
                                Row(
                                  children: [
                                    _buildStatCard(
                                      icon: Icons.repeat_rounded,
                                      value: '${_progressLog.sets}',
                                      label: 'Sets',
                                    ),
                                    const SizedBox(width: 12),
                                    _buildStatCard(
                                      icon: Icons.format_list_numbered_rounded,
                                      value: '${_progressLog.reps}',
                                      label: 'Reps',
                                    ),
                                    const SizedBox(width: 12),
                                    _buildStatCard(
                                      icon: Icons.monitor_weight_rounded,
                                      value: _progressLog.weight.isEmpty
                                          ? '-'
                                          : _progressLog.weight,
                                      label: 'Weight',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                _buildInfoRow(
                                  icon: Icons.calendar_today_rounded,
                                  label: 'Date',
                                  value: _formatDate(_progressLog.date),
                                ),
                                _buildInfoRow(
                                  icon: Icons.fitness_center_rounded,
                                  label: 'Workout',
                                  value: _workoutName,
                                ),
                                _buildInfoRow(
                                  icon: Icons.sports_gymnastics_rounded,
                                  label: 'Exercise',
                                  value: _exerciseName,
                                ),
                                if (_progressLog.notes.isNotEmpty)
                                  _buildInfoRow(
                                    icon: Icons.notes_rounded,
                                    label: 'Notes',
                                    value: _progressLog.notes,
                                  ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: _editProgress,
                                        icon: const Icon(Icons.edit_rounded),
                                        label: const Text('Edit'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.18,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _deleteProgress,
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                        ),
                                        label: const Text('Delete'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
        ],
      ),
    );
  }
}
