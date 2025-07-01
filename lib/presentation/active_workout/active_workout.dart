import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/exercise_display_widget.dart';
import './widgets/workout_completion_widget.dart';
import './widgets/workout_controls_widget.dart';
import './widgets/workout_progress_widget.dart';
import './widgets/workout_timer_widget.dart';

class ActiveWorkout extends StatefulWidget {
  const ActiveWorkout({super.key});

  @override
  State<ActiveWorkout> createState() => _ActiveWorkoutState();
}

class _ActiveWorkoutState extends State<ActiveWorkout>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _celebrationController;

  bool _isWorkoutActive = true;
  bool _isPaused = false;
  bool _isResting = false;
  bool _isWorkoutCompleted = false;
  int _currentExerciseIndex = 0;
  int _workoutTimeRemaining = 45; // seconds
  int _restTimeRemaining = 15; // seconds

  // Mock workout data
  final List<Map<String, dynamic>> _workoutExercises = [
    {
      "id": 1,
      "name": "Jumping Jacks",
      "duration": 45,
      "restDuration": 15,
      "instructions": "Jump while spreading legs and raising arms overhead",
      "image":
          "https://images.pexels.com/photos/416809/pexels-photo-416809.jpeg?auto=compress&cs=tinysrgb&w=800",
      "difficulty": "Beginner",
      "caloriesBurn": 8
    },
    {
      "id": 2,
      "name": "Push-Ups",
      "duration": 45,
      "restDuration": 15,
      "instructions":
          "Lower body until chest nearly touches floor, then push up",
      "image":
          "https://images.pexels.com/photos/176782/pexels-photo-176782.jpeg?auto=compress&cs=tinysrgb&w=800",
      "difficulty": "Intermediate",
      "caloriesBurn": 10
    },
    {
      "id": 3,
      "name": "Squats",
      "duration": 45,
      "restDuration": 15,
      "instructions":
          "Lower hips back and down, keeping chest up and knees behind toes",
      "image":
          "https://images.pexels.com/photos/1552252/pexels-photo-1552252.jpeg?auto=compress&cs=tinysrgb&w=800",
      "difficulty": "Beginner",
      "caloriesBurn": 12
    },
    {
      "id": 4,
      "name": "Plank",
      "duration": 45,
      "restDuration": 15,
      "instructions":
          "Hold body straight from head to heels, engaging core muscles",
      "image":
          "https://images.pexels.com/photos/3076509/pexels-photo-3076509.jpeg?auto=compress&cs=tinysrgb&w=800",
      "difficulty": "Intermediate",
      "caloriesBurn": 6
    },
    {
      "id": 5,
      "name": "Burpees",
      "duration": 45,
      "restDuration": 15,
      "instructions":
          "Drop to squat, jump back to plank, do push-up, jump forward, then jump up",
      "image":
          "https://images.pexels.com/photos/4162449/pexels-photo-4162449.jpeg?auto=compress&cs=tinysrgb&w=800",
      "difficulty": "Advanced",
      "caloriesBurn": 15
    },
    {
      "id": 6,
      "name": "Mountain Climbers",
      "duration": 45,
      "restDuration": 15,
      "instructions":
          "In plank position, alternate bringing knees to chest rapidly",
      "image":
          "https://images.pexels.com/photos/4162438/pexels-photo-4162438.jpeg?auto=compress&cs=tinysrgb&w=800",
      "difficulty": "Intermediate",
      "caloriesBurn": 14
    },
    {
      "id": 7,
      "name": "Lunges",
      "duration": 45,
      "restDuration": 15,
      "instructions":
          "Step forward, lower hips until both knees bent at 90 degrees",
      "image":
          "https://images.pexels.com/photos/4162451/pexels-photo-4162451.jpeg?auto=compress&cs=tinysrgb&w=800",
      "difficulty": "Beginner",
      "caloriesBurn": 9
    },
    {
      "id": 8,
      "name": "High Knees",
      "duration": 45,
      "restDuration": 0,
      "instructions": "Run in place, bringing knees up to waist level",
      "image":
          "https://images.pexels.com/photos/4162440/pexels-photo-4162440.jpeg?auto=compress&cs=tinysrgb&w=800",
      "difficulty": "Beginner",
      "caloriesBurn": 11
    }
  ];

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: Duration(seconds: _workoutTimeRemaining),
      vsync: this,
    );
    _celebrationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _startTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _timerController.dispose();
    _celebrationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _startTimer() {
    if (!_isPaused && _isWorkoutActive) {
      _timerController.forward().then((_) {
        if (_isResting) {
          _nextExercise();
        } else {
          _startRest();
        }
      });

      // Update timer every second
      _timerController.addListener(() {
        if (mounted) {
          setState(() {
            if (_isResting) {
              _restTimeRemaining = ((_workoutExercises[_currentExerciseIndex]
                          ["restDuration"] as int) *
                      (1 - _timerController.value))
                  .round();
            } else {
              _workoutTimeRemaining = ((_workoutExercises[_currentExerciseIndex]
                          ["duration"] as int) *
                      (1 - _timerController.value))
                  .round();
            }
          });
        }
      });
    }
  }

  void _startRest() {
    if (_currentExerciseIndex < _workoutExercises.length - 1) {
      setState(() {
        _isResting = true;
        _restTimeRemaining =
            _workoutExercises[_currentExerciseIndex]["restDuration"] as int;
      });

      _timerController.reset();
      _timerController.duration = Duration(seconds: _restTimeRemaining);
      _startTimer();

      // Haptic feedback
      HapticFeedback.mediumImpact();
    } else {
      _completeWorkout();
    }
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _workoutExercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _isResting = false;
        _workoutTimeRemaining =
            _workoutExercises[_currentExerciseIndex]["duration"] as int;
      });

      _timerController.reset();
      _timerController.duration = Duration(seconds: _workoutTimeRemaining);
      _startTimer();

      // Haptic feedback
      HapticFeedback.lightImpact();
    } else {
      _completeWorkout();
    }
  }

  void _skipExercise() {
    _timerController.stop();
    if (_isResting) {
      _nextExercise();
    } else {
      _startRest();
    }
    HapticFeedback.selectionClick();
  }

  void _pauseWorkout() {
    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      _timerController.stop();
    } else {
      _startTimer();
    }

    HapticFeedback.mediumImpact();
  }

  void _completeWorkout() {
    setState(() {
      _isWorkoutCompleted = true;
      _isWorkoutActive = false;
    });

    _celebrationController.forward();
    HapticFeedback.heavyImpact();
  }

  void _endWorkout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'End Workout?',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to end this workout? Your progress will be saved.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              child: const Text('End Workout'),
            ),
          ],
        );
      },
    );
  }

  double get _workoutProgress {
    return (_currentExerciseIndex + (_isResting ? 1 : _timerController.value)) /
        _workoutExercises.length;
  }

  int get _totalCaloriesBurned {
    int calories = 0;
    for (int i = 0; i <= _currentExerciseIndex; i++) {
      if (i < _currentExerciseIndex ||
          (!_isResting && _timerController.value > 0)) {
        calories += _workoutExercises[i]["caloriesBurn"] as int;
      }
    }
    return calories;
  }

  @override
  Widget build(BuildContext context) {
    if (_isWorkoutCompleted) {
      return WorkoutCompletionWidget(
        totalTime: _workoutExercises.fold<int>(
            0,
            (sum, exercise) =>
                sum +
                (exercise["duration"] as int) +
                (exercise["restDuration"] as int)),
        caloriesBurned: _totalCaloriesBurned,
        exercisesCompleted: _workoutExercises.length,
        onContinue: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        celebrationController: _celebrationController,
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            WorkoutProgressWidget(
              progress: _workoutProgress,
              currentExercise: _currentExerciseIndex + 1,
              totalExercises: _workoutExercises.length,
            ),

            // Main workout content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Timer section
                    Expanded(
                      flex: 3,
                      child: WorkoutTimerWidget(
                        timeRemaining: _isResting
                            ? _restTimeRemaining
                            : _workoutTimeRemaining,
                        totalTime: _isResting
                            ? _workoutExercises[_currentExerciseIndex]
                                ["restDuration"] as int
                            : _workoutExercises[_currentExerciseIndex]
                                ["duration"] as int,
                        isResting: _isResting,
                        isPaused: _isPaused,
                        timerController: _timerController,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Exercise display section
                    Expanded(
                      flex: 4,
                      child: ExerciseDisplayWidget(
                        exercise: _workoutExercises[_currentExerciseIndex],
                        nextExercise:
                            _currentExerciseIndex < _workoutExercises.length - 1
                                ? _workoutExercises[_currentExerciseIndex + 1]
                                : null,
                        isResting: _isResting,
                        isPaused: _isPaused,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Control buttons
                    WorkoutControlsWidget(
                      isPaused: _isPaused,
                      onPause: _pauseWorkout,
                      onSkip: _skipExercise,
                      onEnd: _endWorkout,
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
