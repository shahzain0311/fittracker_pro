import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/search_history_widget.dart';
import './widgets/workout_card_widget.dart';

class WorkoutLibrary extends StatefulWidget {
  const WorkoutLibrary({super.key});

  @override
  State<WorkoutLibrary> createState() => _WorkoutLibraryState();
}

class _WorkoutLibraryState extends State<WorkoutLibrary>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'All';
  String _sortBy = 'Popular';
  bool _isSearching = false;
  bool _showSearchHistory = false;
  final List<String> _searchHistory = ['Push ups', 'Cardio workout', 'Yoga flow'];

  final List<String> _categories = ['All', 'Cardio', 'Strength', 'Flexibility'];
  final List<String> _sortOptions = [
    'Popular',
    'Duration',
    'Difficulty',
    'Recently Added'
  ];

  // Mock workout data
  final List<Map<String, dynamic>> _workouts = [
    {
      "id": 1,
      "name": "15 Min Full Body Burn",
      "duration": "15 min",
      "difficulty": "Intermediate",
      "category": "Strength",
      "equipment": "No Equipment",
      "calories": 180,
      "rating": 4.8,
      "thumbnail":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop",
      "isFavorite": false,
      "description":
          "High-intensity full body workout targeting all major muscle groups"
    },
    {
      "id": 2,
      "name": "Morning Yoga Flow",
      "duration": "20 min",
      "difficulty": "Beginner",
      "category": "Flexibility",
      "equipment": "Yoga Mat",
      "calories": 120,
      "rating": 4.9,
      "thumbnail":
          "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop",
      "isFavorite": true,
      "description":
          "Gentle morning yoga sequence to start your day with energy"
    },
    {
      "id": 3,
      "name": "HIIT Cardio Blast",
      "duration": "25 min",
      "difficulty": "Advanced",
      "category": "Cardio",
      "equipment": "No Equipment",
      "calories": 320,
      "rating": 4.7,
      "thumbnail":
          "https://images.unsplash.com/photo-1549476464-37392f717541?w=400&h=300&fit=crop",
      "isFavorite": false,
      "description":
          "Intense cardio workout to boost your metabolism and burn calories"
    },
    {
      "id": 4,
      "name": "Upper Body Strength",
      "duration": "30 min",
      "difficulty": "Intermediate",
      "category": "Strength",
      "equipment": "Dumbbells",
      "calories": 250,
      "rating": 4.6,
      "thumbnail":
          "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=400&h=300&fit=crop",
      "isFavorite": false,
      "description": "Build upper body strength with targeted exercises"
    },
    {
      "id": 5,
      "name": "Core Crusher",
      "duration": "12 min",
      "difficulty": "Beginner",
      "category": "Strength",
      "equipment": "No Equipment",
      "calories": 100,
      "rating": 4.5,
      "thumbnail":
          "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400&h=300&fit=crop",
      "isFavorite": true,
      "description": "Quick and effective core strengthening routine"
    },
    {
      "id": 6,
      "name": "Evening Stretch",
      "duration": "18 min",
      "difficulty": "Beginner",
      "category": "Flexibility",
      "equipment": "No Equipment",
      "calories": 80,
      "rating": 4.8,
      "thumbnail":
          "https://images.unsplash.com/photo-1506629905607-d405b7a30db5?w=400&h=300&fit=crop",
      "isFavorite": false,
      "description": "Relaxing stretches to unwind after a long day"
    }
  ];

  List<Map<String, dynamic>> get _filteredWorkouts {
    List<Map<String, dynamic>> filtered = List.from(_workouts);

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where(
              (workout) => (workout['category'] as String) == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((workout) =>
              (workout['name'] as String).toLowerCase().contains(query) ||
              (workout['category'] as String).toLowerCase().contains(query))
          .toList();
    }

    // Sort workouts
    switch (_sortBy) {
      case 'Duration':
        filtered.sort((a, b) {
          final aDuration = int.parse((a['duration'] as String).split(' ')[0]);
          final bDuration = int.parse((b['duration'] as String).split(' ')[0]);
          return aDuration.compareTo(bDuration);
        });
        break;
      case 'Difficulty':
        final difficultyOrder = {
          'Beginner': 1,
          'Intermediate': 2,
          'Advanced': 3
        };
        filtered.sort((a, b) {
          final aLevel = difficultyOrder[a['difficulty']] ?? 0;
          final bLevel = difficultyOrder[b['difficulty']] ?? 0;
          return aLevel.compareTo(bLevel);
        });
        break;
      case 'Recently Added':
        filtered = filtered.reversed.toList();
        break;
      default: // Popular
        filtered.sort(
            (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      _showSearchHistory = _searchController.text.isEmpty && _isSearching;
    });
  }

  void _onSearchHistoryTap(String query) {
    _searchController.text = query;
    setState(() {
      _showSearchHistory = false;
    });
  }

  void _addToSearchHistory(String query) {
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      });
    }
  }

  void _onWorkoutTap(Map<String, dynamic> workout) {
    Navigator.pushNamed(context, '/workout-detail', arguments: workout);
  }

  void _toggleFavorite(int workoutId) {
    setState(() {
      final index = _workouts.indexWhere((w) => w['id'] == workoutId);
      if (index != -1) {
        _workouts[index]['isFavorite'] =
            !(_workouts[index]['isFavorite'] as bool);
      }
    });
  }

  void _shareWorkout(Map<String, dynamic> workout) {
    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${workout['name']}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSortBottomSheet(),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Mock refresh - in real app, this would fetch new data
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredWorkouts = _filteredWorkouts;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            if (_showSearchHistory) _buildSearchHistorySection(),
            _buildFilterChips(),
            Expanded(
              child: _buildWorkoutList(filteredWorkouts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Workout Library',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to favorites
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: _showSortBottomSheet,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: 'sort',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              onSubmitted: (value) {
                _addToSearchHistory(value);
                setState(() {
                  _showSearchHistory = false;
                });
              },
            ),
          ),
          if (_isSearching)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _showSearchHistory = false;
                });
              },
              child: CustomIconWidget(
                iconName: 'clear',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 18,
              ),
            ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: _showFilterBottomSheet,
            child: CustomIconWidget(
              iconName: 'tune',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistorySection() {
    return SearchHistoryWidget(
      searchHistory: _searchHistory,
      onHistoryTap: _onSearchHistoryTap,
      onClearHistory: () {
        setState(() {
          _searchHistory.clear();
        });
      },
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 6.h,
      margin: EdgeInsets.only(top: 2.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return FilterChipWidget(
            label: category,
            isSelected: _selectedCategory == category,
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildWorkoutList(List<Map<String, dynamic>> workouts) {
    if (workouts.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return WorkoutCardWidget(
            workout: workout,
            onTap: () => _onWorkoutTap(workout),
            onFavoriteToggle: () => _toggleFavorite(workout['id'] as int),
            onShare: () => _shareWorkout(workout),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No exercises found',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your search or filters',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _selectedCategory = 'All';
              });
            },
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Filter Options',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          Divider(color: AppTheme.lightTheme.colorScheme.outline),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Equipment Type',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 2.w,
                  children: ['No Equipment', 'Gym Equipment', 'Yoga Mat']
                      .map((equipment) => FilterChip(
                            label: Text(equipment),
                            selected: false,
                            onSelected: (selected) {},
                          ))
                      .toList(),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Duration Range',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 2.h),
                RangeSlider(
                  values: const RangeValues(10, 30),
                  min: 5,
                  max: 60,
                  divisions: 11,
                  labels: const RangeLabels('10 min', '30 min'),
                  onChanged: (values) {},
                ),
                SizedBox(height: 3.h),
                Text(
                  'Body Focus Areas',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 2.w,
                  children: ['Full Body', 'Upper Body', 'Lower Body', 'Core']
                      .map((area) => FilterChip(
                            label: Text(area),
                            selected: false,
                            onSelected: (selected) {},
                          ))
                      .toList(),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Text(
              'Sort by',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
          ),
          Divider(color: AppTheme.lightTheme.colorScheme.outline),
          ..._sortOptions.map((option) => ListTile(
                title: Text(option),
                trailing: _sortBy == option
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _sortBy = option;
                  });
                  Navigator.pop(context);
                },
              )),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
