import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_card_widget.dart';
import './widgets/goal_setting_card_widget.dart';
import './widgets/metric_card_widget.dart';
import './widgets/weekly_chart_widget.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({super.key});

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking>
    with TickerProviderStateMixin {
  int _selectedBottomNavIndex = 3; // Progress tab active
  String _selectedPeriod = 'Week';
  int _currentWeekIndex = 0;
  late PageController _chartPageController;
  int _currentChartIndex = 0;
  late AnimationController _refreshController;
  bool _isRefreshing = false;

  // Mock data for progress tracking
  final List<Map<String, dynamic>> _weeklyData = [
    {
      'week': 'Current Week',
      'steps': [8500, 12000, 9500, 11200, 10800, 13500, 7200],
      'workouts': [45, 60, 30, 75, 50, 90, 0],
      'calories': [320, 450, 280, 520, 380, 650, 180],
      'days': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    },
    {
      'week': 'Last Week',
      'steps': [7800, 11500, 8900, 10600, 9200, 12800, 6500],
      'workouts': [30, 45, 60, 50, 40, 75, 20],
      'calories': [280, 380, 420, 450, 320, 580, 150],
      'days': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    },
  ];

  final List<Map<String, dynamic>> _metricData = [
    {
      'title': 'Workout Streak',
      'value': '12',
      'unit': 'days',
      'progress': 0.75,
      'trend': 'up',
      'trendValue': '+3',
    },
    {
      'title': 'Step Goals Met',
      'value': '5',
      'unit': 'of 7 days',
      'progress': 0.71,
      'trend': 'up',
      'trendValue': '+1',
    },
    {
      'title': 'Hydration Target',
      'value': '85',
      'unit': '%',
      'progress': 0.85,
      'trend': 'down',
      'trendValue': '-5%',
    },
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'First Mile',
      'description': 'Complete your first workout',
      'icon': 'emoji_events',
      'unlocked': true,
      'unlockedDate': '2024-01-15',
      'progress': 1.0,
    },
    {
      'title': 'Week Warrior',
      'description': 'Complete 7 workouts in a week',
      'icon': 'local_fire_department',
      'unlocked': true,
      'unlockedDate': '2024-01-22',
      'progress': 1.0,
    },
    {
      'title': 'Step Master',
      'description': 'Walk 100,000 steps in a month',
      'icon': 'directions_walk',
      'unlocked': false,
      'progress': 0.68,
      'target': 100000,
      'current': 68000,
    },
    {
      'title': 'Hydration Hero',
      'description': 'Meet hydration goals for 30 days',
      'icon': 'water_drop',
      'unlocked': false,
      'progress': 0.43,
      'target': 30,
      'current': 13,
    },
  ];

  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Daily Steps',
      'current': 10000,
      'unit': 'steps',
      'icon': 'directions_walk',
      'min': 5000,
      'max': 20000,
      'step': 500,
    },
    {
      'title': 'Weekly Workouts',
      'current': 5,
      'unit': 'sessions',
      'icon': 'fitness_center',
      'min': 1,
      'max': 7,
      'step': 1,
    },
    {
      'title': 'Water Intake',
      'current': 8,
      'unit': 'glasses',
      'icon': 'water_drop',
      'min': 4,
      'max': 12,
      'step': 1,
    },
  ];

  final List<String> _chartTypes = ['Steps', 'Workouts', 'Calories'];

  @override
  void initState() {
    super.initState();
    _chartPageController = PageController();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _chartPageController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    _refreshController.reset();
  }

  void _navigateToPeriod(int direction) {
    setState(() {
      if (direction > 0 && _currentWeekIndex < _weeklyData.length - 1) {
        _currentWeekIndex++;
      } else if (direction < 0 && _currentWeekIndex > 0) {
        _currentWeekIndex--;
      }
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/workout-library');
        break;
      case 2:
        Navigator.pushNamed(context, '/active-workout');
        break;
      case 3:
        // Current screen - Progress Tracking
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildDateRangeSelector(),
              SizedBox(height: 2.h),
              _buildChartSection(),
              SizedBox(height: 3.h),
              _buildMetricsSection(),
              SizedBox(height: 3.h),
              _buildAchievementsSection(),
              SizedBox(height: 3.h),
              _buildGoalSettingSection(),
              SizedBox(height: 10.h), // Bottom padding for navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Progress Tracking',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            // Export functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Progress exported successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          icon: CustomIconWidget(
            iconName: 'share',
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _navigateToPeriod(-1),
            icon: CustomIconWidget(
              iconName: 'chevron_left',
              color: _currentWeekIndex > 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['Week', 'Month', 'Year'].map((period) {
                final isSelected = _selectedPeriod == period;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      period,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          IconButton(
            onPressed: () => _navigateToPeriod(1),
            icon: CustomIconWidget(
              iconName: 'chevron_right',
              color: _currentWeekIndex < _weeklyData.length - 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Column(
      children: [
        Container(
          height: 6.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _chartTypes.length,
            itemBuilder: (context, index) {
              final isSelected = _currentChartIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentChartIndex = index;
                  });
                  _chartPageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 3.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _chartTypes[index],
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          height: 30.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          child: PageView.builder(
            controller: _chartPageController,
            onPageChanged: (index) {
              setState(() {
                _currentChartIndex = index;
              });
            },
            itemCount: _chartTypes.length,
            itemBuilder: (context, index) {
              return WeeklyChartWidget(
                chartType: _chartTypes[index],
                data: _weeklyData[_currentWeekIndex],
                isRefreshing: _isRefreshing,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Current Streaks',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _metricData.length,
            itemBuilder: (context, index) {
              return Container(
                width: 70.w,
                margin: EdgeInsets.only(right: 3.w),
                child: MetricCardWidget(
                  data: _metricData[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full achievements screen
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _achievements.length,
            itemBuilder: (context, index) {
              return Container(
                width: 65.w,
                margin: EdgeInsets.only(right: 3.w),
                child: AchievementCardWidget(
                  data: _achievements[index],
                  onTap: () {
                    _showAchievementDetails(_achievements[index]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGoalSettingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Goal Settings',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          itemCount: _goals.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              child: GoalSettingCardWidget(
                data: _goals[index],
                onValueChanged: (newValue) {
                  setState(() {
                    _goals[index]['current'] = newValue;
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedBottomNavIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _selectedBottomNavIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'fitness_center',
            color: _selectedBottomNavIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Workouts',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'play_circle',
            color: _selectedBottomNavIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Active',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'analytics',
            color: _selectedBottomNavIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Progress',
        ),
      ],
    );
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            CustomIconWidget(
              iconName: achievement['icon'] as String,
              color: achievement['unlocked'] == true
                  ? AppTheme.successLight
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              achievement['title'] as String,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                achievement['description'] as String,
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            if (achievement['unlocked'] == true) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Unlocked on ${achievement['unlockedDate']}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ] else ...[
              Container(
                width: 80.w,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: AppTheme.lightTheme.textTheme.labelMedium,
                        ),
                        Text(
                          '${achievement['current']} / ${achievement['target']}',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: achievement['progress'] as double,
                      backgroundColor: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 6.h),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
