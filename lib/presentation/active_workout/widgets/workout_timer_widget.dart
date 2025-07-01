import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WorkoutTimerWidget extends StatelessWidget {
  final int timeRemaining;
  final int totalTime;
  final bool isResting;
  final bool isPaused;
  final AnimationController timerController;

  const WorkoutTimerWidget({
    super.key,
    required this.timeRemaining,
    required this.totalTime,
    required this.isResting,
    required this.isPaused,
    required this.timerController,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        totalTime > 0 ? (totalTime - timeRemaining) / totalTime : 0.0;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Timer circle
          SizedBox(
            width: 60.w,
            height: 60.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),

                // Progress circle
                SizedBox(
                  width: 55.w,
                  height: 55.w,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: isResting
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2)
                        : AppTheme.warningLight.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isResting
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.warningLight,
                    ),
                  ),
                ),

                // Timer text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(timeRemaining),
                      style:
                          AppTheme.lightTheme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isResting
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.warningLight,
                      ),
                    ),
                    if (isPaused)
                      Container(
                        margin: EdgeInsets.only(top: 1.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'PAUSED',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Timer status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isResting
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.warningLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isResting
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3)
                    : AppTheme.warningLight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: isResting ? 'pause' : 'fitness_center',
                  color: isResting
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.warningLight,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  isResting ? 'REST TIME' : 'WORK TIME',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isResting
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.warningLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
