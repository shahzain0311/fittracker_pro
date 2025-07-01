import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/workout_library/workout_library.dart';
import '../presentation/workout_detail/workout_detail.dart';
import '../presentation/active_workout/active_workout.dart';
import '../presentation/progress_tracking/progress_tracking.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String dashboard = '/dashboard';
  static const String workoutLibrary = '/workout-library';
  static const String workoutDetail = '/workout-detail';
  static const String activeWorkout = '/active-workout';
  static const String progressTracking = '/progress-tracking';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => LoginScreen(),
    loginScreen: (context) => LoginScreen(),
    dashboard: (context) => Dashboard(),
    workoutLibrary: (context) => WorkoutLibrary(),
    workoutDetail: (context) => WorkoutDetail(),
    activeWorkout: (context) => ActiveWorkout(),
    progressTracking: (context) => ProgressTracking(),
    // TODO: Add your other routes here
  };
}
