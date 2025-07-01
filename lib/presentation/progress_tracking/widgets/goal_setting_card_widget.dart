import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoalSettingCardWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(int) onValueChanged;

  const GoalSettingCardWidget({
    super.key,
    required this.data,
    required this.onValueChanged,
  });

  @override
  State<GoalSettingCardWidget> createState() => _GoalSettingCardWidgetState();
}

class _GoalSettingCardWidgetState extends State<GoalSettingCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _incrementValue() {
    final currentValue = widget.data['current'] as int;
    final maxValue = widget.data['max'] as int;
    final step = widget.data['step'] as int;

    if (currentValue + step <= maxValue) {
      widget.onValueChanged(currentValue + step);
    }
  }

  void _decrementValue() {
    final currentValue = widget.data['current'] as int;
    final minValue = widget.data['min'] as int;
    final step = widget.data['step'] as int;

    if (currentValue - step >= minValue) {
      widget.onValueChanged(currentValue - step);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: widget.data['icon'] as String,
                          color: AppTheme.lightTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data['title'] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Current: ${widget.data['current']} ${widget.data['unit']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    _buildControlButton(
                      icon: 'remove',
                      onPressed: _decrementValue,
                      isEnabled: widget.data['current'] > widget.data['min'],
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${widget.data['current']}',
                              style: AppTheme
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                            Text(
                              widget.data['unit'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildControlButton(
                      icon: 'add',
                      onPressed: _incrementValue,
                      isEnabled: widget.data['current'] < widget.data['max'],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildProgressSlider(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required String icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: isEnabled
            ? AppTheme.lightTheme.primaryColor
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: isEnabled
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSlider() {
    final currentValue = widget.data['current'] as int;
    final minValue = widget.data['min'] as int;
    final maxValue = widget.data['max'] as int;
    final progress = (currentValue - minValue) / (maxValue - minValue);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Range',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '$minValue - $maxValue ${widget.data['unit']}',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.lightTheme.primaryColor,
          ),
          minHeight: 6,
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$minValue',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '$maxValue',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
