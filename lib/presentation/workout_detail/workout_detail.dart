import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/exercise_list_item_widget.dart';
import './widgets/info_card_widget.dart';
import './widgets/instruction_step_widget.dart';
import './widgets/related_workout_card_widget.dart';
import './widgets/review_item_widget.dart';

class WorkoutDetail extends StatefulWidget {
  const WorkoutDetail({super.key});

  @override
  State<WorkoutDetail> createState() => _WorkoutDetailState();
}

class _WorkoutDetailState extends State<WorkoutDetail> {
  bool isInstructionsExpanded = false;
  bool isFavorite = false;

  // Mock workout data
  final Map<String, dynamic> workoutData = {
    "id": 1,
    "title": "15 Min Full Body Burn",
    "difficulty": "Intermediate",
    "duration": "15 min",
    "calories": 180,
    "equipment": "No equipment",
    "muscleGroups": ["Full Body", "Core", "Cardio"],
    "rating": 4.8,
    "totalRatings": 1247,
    "heroImage":
        "https://images.pexels.com/photos/416809/pexels-photo-416809.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "description":
        "High-intensity full body workout designed to burn maximum calories in minimal time. Perfect for busy schedules.",
    "instructions": [
      "Warm up with 2 minutes of light movement",
      "Perform each exercise for 45 seconds",
      "Rest for 15 seconds between exercises",
      "Complete 3 rounds of the circuit",
      "Cool down with 3 minutes of stretching"
    ],
    "exercises": [
      {
        "id": 1,
        "name": "Jumping Jacks",
        "reps": "45 sec",
        "thumbnail":
            "https://images.pexels.com/photos/863988/pexels-photo-863988.jpeg?auto=compress&cs=tinysrgb&w=400",
        "description": "Full body cardio exercise"
      },
      {
        "id": 2,
        "name": "Push-Ups",
        "reps": "12-15 reps",
        "thumbnail":
            "https://images.pexels.com/photos/176782/pexels-photo-176782.jpeg?auto=compress&cs=tinysrgb&w=400",
        "description": "Upper body strength exercise"
      },
      {
        "id": 3,
        "name": "Squats",
        "reps": "15-20 reps",
        "thumbnail":
            "https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg?auto=compress&cs=tinysrgb&w=400",
        "description": "Lower body strength exercise"
      },
      {
        "id": 4,
        "name": "Mountain Climbers",
        "reps": "30 sec",
        "thumbnail":
            "https://images.pexels.com/photos/1552106/pexels-photo-1552106.jpeg?auto=compress&cs=tinysrgb&w=400",
        "description": "Core and cardio exercise"
      }
    ],
    "reviews": [
      {
        "id": 1,
        "userName": "Sarah M.",
        "rating": 5,
        "comment": "Amazing workout! Perfect for my morning routine.",
        "date": "2 days ago",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
      },
      {
        "id": 2,
        "userName": "Mike R.",
        "rating": 4,
        "comment": "Great intensity, really gets your heart pumping!",
        "date": "1 week ago",
        "avatar":
            "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
      }
    ],
    "relatedWorkouts": [
      {
        "id": 2,
        "title": "20 Min HIIT Blast",
        "duration": "20 min",
        "difficulty": "Advanced",
        "image":
            "https://images.pexels.com/photos/1552252/pexels-photo-1552252.jpeg?auto=compress&cs=tinysrgb&w=400",
        "calories": 240
      },
      {
        "id": 3,
        "title": "Beginner Strength",
        "duration": "25 min",
        "difficulty": "Beginner",
        "image":
            "https://images.pexels.com/photos/1552103/pexels-photo-1552103.jpeg?auto=compress&cs=tinysrgb&w=400",
        "calories": 150
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWorkoutHeader(),
                _buildInfoCards(),
                _buildInstructionsSection(),
                _buildExerciseList(),
                _buildActionButtons(),
                _buildReviewsSection(),
                _buildRelatedWorkouts(),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 30.h,
      pinned: true,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      leading: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () {
              // Share functionality
            },
            icon: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CustomImageWidget(
              imageUrl: workoutData["heroImage"] as String,
              width: double.infinity,
              height: 30.h,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    // Video preview functionality
                  },
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutHeader() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  workoutData["title"] as String,
                  style: AppTheme.lightTheme.textTheme.headlineMedium,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      _getDifficultyColor(workoutData["difficulty"] as String),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  workoutData["difficulty"] as String,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                workoutData["duration"] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 4.w),
              CustomIconWidget(
                iconName: 'star',
                color: Colors.amber,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                "${workoutData["rating"]} (${workoutData["totalRatings"]})",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            workoutData["description"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: InfoCardWidget(
              icon: 'fitness_center',
              title: 'Equipment',
              value: workoutData["equipment"] as String,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: InfoCardWidget(
              icon: 'local_fire_department',
              title: 'Calories',
              value: "${workoutData["calories"]} kcal",
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: InfoCardWidget(
              icon: 'accessibility_new',
              title: 'Muscles',
              value: (workoutData["muscleGroups"] as List).join(", "),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isInstructionsExpanded = !isInstructionsExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'list_alt',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Instructions',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName:
                        isInstructionsExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isInstructionsExpanded) ...[
            Divider(
              height: 1,
              color: AppTheme.lightTheme.dividerColor,
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: (workoutData["instructions"] as List<String>)
                    .asMap()
                    .entries
                    .map((entry) => InstructionStepWidget(
                          stepNumber: entry.key + 1,
                          instruction: entry.value,
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercise List',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (workoutData["exercises"] as List).length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final exercise = (workoutData["exercises"] as List)[index]
                  as Map<String, dynamic>;
              return ExerciseListItemWidget(
                exercise: exercise,
                onTap: () {
                  // Navigate to exercise detail
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/active-workout');
              },
              child: Text('Start Workout'),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              icon: CustomIconWidget(
                iconName: isFavorite ? 'favorite' : 'favorite_border',
                color:
                    isFavorite ? Colors.red : AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              label: Text(
                  isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reviews',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Write review functionality
                },
                child: Text('Write Review'),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (workoutData["reviews"] as List).length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final review = (workoutData["reviews"] as List)[index]
                  as Map<String, dynamic>;
              return ReviewItemWidget(review: review);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedWorkouts() {
    return Container(
      margin: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Workouts',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 25.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: (workoutData["relatedWorkouts"] as List).length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final workout = (workoutData["relatedWorkouts"] as List)[index]
                    as Map<String, dynamic>;
                return RelatedWorkoutCardWidget(
                  workout: workout,
                  onTap: () {
                    Navigator.pushNamed(context, '/workout-detail');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppTheme.successLight;
      case 'intermediate':
        return AppTheme.warningLight;
      case 'advanced':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }
}
