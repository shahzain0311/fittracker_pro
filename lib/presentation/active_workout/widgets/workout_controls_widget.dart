import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WorkoutControlsWidget extends StatelessWidget {
  final bool isPaused;
  final VoidCallback onPause;
  final VoidCallback onSkip;
  final VoidCallback onEnd;

  const WorkoutControlsWidget({
    super.key,
    required this.isPaused,
    required this.onPause,
    required this.onSkip,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Row(
        children: [
          // Pause/Resume button
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 12.h,
              child: ElevatedButton(
                onPressed: onPause,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPaused
                      ? AppTheme.successLight
                      : AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: Colors.black.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: isPaused ? 'play_arrow' : 'pause',
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isPaused ? 'Resume' : 'Pause',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Skip button
          Expanded(
            child: SizedBox(
              height: 12.h,
              child: OutlinedButton(
                onPressed: onSkip,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'skip_next',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 28,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Skip',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // End workout button
          Expanded(
            child: SizedBox(
              height: 12.h,
              child: OutlinedButton(
                onPressed: onEnd,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.errorLight,
                  side: BorderSide(
                    color: AppTheme.errorLight,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'stop',
                      color: AppTheme.errorLight,
                      size: 28,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'End',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.errorLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
