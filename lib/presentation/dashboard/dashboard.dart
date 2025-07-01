import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/metric_card_widget.dart';
import './widgets/quick_workout_widget.dart';
import './widgets/recent_activity_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  bool _isRefreshing = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Alex Johnson",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "greeting": "Good Morning"
  };

  // Mock fitness metrics
  final List<Map<String, dynamic>> fitnessMetrics = [
    {
      "id": 1,
      "title": "Steps",
      "current": 8542,
      "target": 10000,
      "unit": "steps",
      "icon": "directions_walk",
      "color": 0xFF2563EB,
      "progress": 0.85
    },
    {
      "id": 2,
      "title": "Calories",
      "current": 1847,
      "target": 2200,
      "unit": "kcal",
      "icon": "local_fire_department",
      "color": 0xFFDC2626,
      "progress": 0.84
    },
    {
      "id": 3,
      "title": "Water",
      "current": 6,
      "target": 8,
      "unit": "glasses",
      "icon": "water_drop",
      "color": 0xFF059669,
      "progress": 0.75
    },
    {
      "id": 4,
      "title": "Active",
      "current": 45,
      "target": 60,
      "unit": "min",
      "icon": "timer",
      "color": 0xFF7C3AED,
      "progress": 0.75
    }
  ];

  // Mock quick workouts
  final List<Map<String, dynamic>> quickWorkouts = [
    {
      "id": 1,
      "title": "Morning Stretch",
      "duration": "10 min",
      "difficulty": "Beginner",
      "image":
          "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=300&h=200&fit=crop",
      "exercises": 8
    },
    {
      "id": 2,
      "title": "HIIT Cardio",
      "duration": "15 min",
      "difficulty": "Intermediate",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop",
      "exercises": 12
    },
    {
      "id": 3,
      "title": "Core Blast",
      "duration": "12 min",
      "difficulty": "Advanced",
      "image":
          "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=300&h=200&fit=crop",
      "exercises": 10
    }
  ];

  // Mock recent activities
  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "type": "workout",
      "title": "Full Body Workout completed",
      "subtitle": "Burned 245 calories in 25 minutes",
      "timestamp": "2 hours ago",
      "icon": "fitness_center",
      "color": 0xFF2563EB
    },
    {
      "id": 2,
      "type": "achievement",
      "title": "Daily Step Goal Achieved!",
      "subtitle": "You walked 10,247 steps today",
      "timestamp": "Yesterday",
      "icon": "emoji_events",
      "color": 0xFFF59E0B
    },
    {
      "id": 3,
      "type": "hydration",
      "title": "Hydration Reminder",
      "subtitle": "Great job staying hydrated today!",
      "timestamp": "3 hours ago",
      "icon": "water_drop",
      "color": 0xFF059669
    }
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/workout-library');
        break;
      case 2:
        Navigator.pushNamed(context, '/progress-tracking');
        break;
      case 3:
        Navigator.pushNamed(context, '/login-screen');
        break;
    }
  }

  void _startWorkout() {
    Navigator.pushNamed(context, '/workout-library');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              // Header with greeting and avatar
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData["greeting"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              userData["name"] as String,
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to profile
                        },
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.primaryColor,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: CustomImageWidget(
                              imageUrl: userData["avatar"] as String,
                              width: 12.w,
                              height: 12.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Today's Metrics
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Text(
                        "Today's Progress",
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(
                        height: 20.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: fitnessMetrics.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 3.w),
                          itemBuilder: (context, index) {
                            final metric = fitnessMetrics[index];
                            return MetricCardWidget(
                              title: metric["title"] as String,
                              current: metric["current"] as int,
                              target: metric["target"] as int,
                              unit: metric["unit"] as String,
                              iconName: metric["icon"] as String,
                              color: Color(metric["color"] as int),
                              progress: metric["progress"] as double,
                              onTap: () {
                                // Navigate to detailed view
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Quick Start Workout
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Quick Start Workout",
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/workout-library');
                            },
                            child: Text(
                              "See All",
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      SizedBox(
                        height: 25.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: quickWorkouts.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 3.w),
                          itemBuilder: (context, index) {
                            final workout = quickWorkouts[index];
                            return QuickWorkoutWidget(
                              title: workout["title"] as String,
                              duration: workout["duration"] as String,
                              difficulty: workout["difficulty"] as String,
                              imageUrl: workout["image"] as String,
                              exercises: workout["exercises"] as int,
                              onTap: () {
                                Navigator.pushNamed(context, '/workout-detail');
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Recent Activity
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      Text(
                        "Recent Activity",
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ),

              // Recent Activity List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final activity = recentActivities[index];
                    return RecentActivityWidget(
                      title: activity["title"] as String,
                      subtitle: activity["subtitle"] as String,
                      timestamp: activity["timestamp"] as String,
                      iconName: activity["icon"] as String,
                      color: Color(activity["color"] as int),
                      onTap: () {
                        // Handle activity tap
                      },
                    );
                  },
                  childCount: recentActivities.length,
                ),
              ),

              // Bottom padding
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startWorkout,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: AppTheme.onPrimaryLight,
        icon: CustomIconWidget(
          iconName: 'play_arrow',
          color: AppTheme.onPrimaryLight,
          size: 24,
        ),
        label: Text(
          'Start Workout',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.onPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryLight,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'fitness_center',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
