import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WeeklyChartWidget extends StatefulWidget {
  final String chartType;
  final Map<String, dynamic> data;
  final bool isRefreshing;

  const WeeklyChartWidget({
    super.key,
    required this.chartType,
    required this.data,
    this.isRefreshing = false,
  });

  @override
  State<WeeklyChartWidget> createState() => _WeeklyChartWidgetState();
}

class _WeeklyChartWidgetState extends State<WeeklyChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${widget.chartType} Overview',
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            if (widget.isRefreshing)
              SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.primaryColor))),
          ]),
          SizedBox(height: 1.h),
          Text(widget.data['week'] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 3.h),
          Expanded(
              child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return BarChart(BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: _getMaxY(),
                        barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                                tooltipBorder: BorderSide(
                                    color:
                                        AppTheme.lightTheme.colorScheme.outline,
                                    width: 1),
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                      '${widget.data['days'][group.x.toInt()]}\n',
                                      AppTheme.lightTheme.textTheme.labelSmall!,
                                      children: [
                                        TextSpan(
                                            text:
                                                '${rod.toY.round()} ${_getUnit()}',
                                            style: AppTheme.lightTheme.textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                    color: AppTheme.lightTheme
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                      ]);
                                }),
                            touchCallback:
                                (FlTouchEvent event, barTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    barTouchResponse == null ||
                                    barTouchResponse.spot == null) {
                                  _touchedIndex = -1;
                                  return;
                                }
                                _touchedIndex =
                                    barTouchResponse.spot!.touchedBarGroupIndex;
                              });
                            }),
                        titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                      final days =
                                          widget.data['days'] as List<String>;
                                      if (value.toInt() >= 0 &&
                                          value.toInt() < days.length) {
                                        return Padding(
                                            padding: EdgeInsets.only(top: 1.h),
                                            child: Text(days[value.toInt()],
                                                style: AppTheme.lightTheme
                                                    .textTheme.labelSmall
                                                    ?.copyWith(
                                                        color: AppTheme
                                                            .lightTheme
                                                            .colorScheme
                                                            .onSurfaceVariant)));
                                      }
                                      return const Text('');
                                    },
                                    reservedSize: 30)),
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    interval: _getMaxY() / 4,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                      return Text(_formatYAxisValue(value),
                                          style: AppTheme
                                              .lightTheme.textTheme.labelSmall
                                              ?.copyWith(
                                                  color: AppTheme
                                                      .lightTheme
                                                      .colorScheme
                                                      .onSurfaceVariant));
                                    }))),
                        borderData: FlBorderData(show: false),
                        barGroups: _buildBarGroups(),
                        gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: _getMaxY() / 4,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                                  strokeWidth: 1);
                            })));
                  })),
        ]));
  }

  List<BarChartGroupData> _buildBarGroups() {
    final List<dynamic> values = _getChartData();

    return List.generate(values.length, (index) {
      final isTouched = index == _touchedIndex;
      final barHeight = (values[index] as num).toDouble() * _animation.value;

      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: barHeight,
            color: isTouched
                ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8)
                : AppTheme.lightTheme.primaryColor,
            width: isTouched ? 20 : 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: _getMaxY(),
                color:
                    AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1))),
      ]);
    });
  }

  List<dynamic> _getChartData() {
    switch (widget.chartType.toLowerCase()) {
      case 'steps':
        return widget.data['steps'] as List<dynamic>;
      case 'workouts':
        return widget.data['workouts'] as List<dynamic>;
      case 'calories':
        return widget.data['calories'] as List<dynamic>;
      default:
        return widget.data['steps'] as List<dynamic>;
    }
  }

  double _getMaxY() {
    final List<dynamic> values = _getChartData();
    final maxValue = values
        .map((e) => (e as num).toDouble())
        .reduce((a, b) => a > b ? a : b);

    switch (widget.chartType.toLowerCase()) {
      case 'steps':
        return (maxValue / 1000).ceil() * 1000 + 2000;
      case 'workouts':
        return (maxValue / 10).ceil() * 10 + 20;
      case 'calories':
        return (maxValue / 100).ceil() * 100 + 100;
      default:
        return maxValue + (maxValue * 0.2);
    }
  }

  String _getUnit() {
    switch (widget.chartType.toLowerCase()) {
      case 'steps':
        return 'steps';
      case 'workouts':
        return 'min';
      case 'calories':
        return 'cal';
      default:
        return '';
    }
  }

  String _formatYAxisValue(double value) {
    switch (widget.chartType.toLowerCase()) {
      case 'steps':
        return '${(value / 1000).toStringAsFixed(0)}k';
      case 'workouts':
        return '${value.toInt()}m';
      case 'calories':
        return '${value.toInt()}';
      default:
        return value.toInt().toString();
    }
  }
}
