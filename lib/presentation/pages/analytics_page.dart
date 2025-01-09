import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solutech_interview/domain/models/habit.dart';
import 'package:solutech_interview/presentation/blocs/habit/habit_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

@RoutePage()
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Overview',
                icon: isSmallScreen ? null : const Icon(Icons.dashboard),
              ),
              Tab(
                text: 'Trends',
                icon: isSmallScreen ? null : const Icon(Icons.trending_up),
              ),
              Tab(
                text: 'Habits',
                icon: isSmallScreen ? null : const Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? double.infinity : 1200,
            ),
            child: TabBarView(
              children: [
                _OverviewTab(isSmallScreen: isSmallScreen),
                _TrendsTab(isSmallScreen: isSmallScreen),
                _HabitsTab(isSmallScreen: isSmallScreen),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final bool isSmallScreen;

  const _OverviewTab({required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildOverviewCard(context, state),
            const SizedBox(height: 16),
            _buildWeeklyProgressChart(context, state),
            const SizedBox(height: 16),
            _buildHabitDistributionChart(context, state),
          ],
        );
      },
    );
  }

  Widget _buildOverviewCard(BuildContext context, HabitState state) {
    final theme = Theme.of(context);
    final completionRate = _calculateCompletionRate(state);
    final totalXP = _calculateTotalXP(state);
    final averageStreak = _calculateAverageStreak(state);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Progress',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context,
                  'Completion Rate',
                  '${(completionRate * 100).toStringAsFixed(1)}%',
                  Icons.check_circle,
                ),
                _buildStatColumn(
                  context,
                  'Total XP',
                  totalXP.toString(),
                  Icons.star,
                ),
                _buildStatColumn(
                  context,
                  'Avg. Streak',
                  averageStreak.toStringAsFixed(1),
                  Icons.local_fire_department,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgressChart(BuildContext context, HabitState state) {
    final theme = Theme.of(context);
    final weeklyData = _getWeeklyCompletionData(state);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Progress',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return Text(days[value.toInt()]);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}%');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: weeklyData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: theme.colorScheme.primary,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitDistributionChart(BuildContext context, HabitState state) {
    final theme = Theme.of(context);
    final distribution = _getHabitDistribution(state);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habit Distribution',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: distribution.entries.map((entry) {
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: '${entry.key}\n${entry.value}%',
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  double _calculateCompletionRate(HabitState state) {
    if (state.habits.isEmpty) return 0;

    final totalCompletions = state.habits.fold<int>(
      0,
      (sum, habit) => sum + habit.completedDates.length,
    );

    final totalDays = state.habits.fold<int>(
      0,
      (sum, habit) =>
          sum + DateTime.now().difference(habit.startDate).inDays + 1,
    );

    return totalDays > 0 ? totalCompletions / totalDays : 0;
  }

  int _calculateTotalXP(HabitState state) {
    return state.habits.fold<int>(
      0,
      (sum, habit) => sum + habit.xp,
    );
  }

  double _calculateAverageStreak(HabitState state) {
    if (state.habits.isEmpty) return 0;

    final totalStreaks = state.habits.fold<int>(
      0,
      (sum, habit) => sum + habit.currentStreak,
    );

    return totalStreaks / state.habits.length;
  }

  List<double> _getWeeklyCompletionData(HabitState state) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final data = List.generate(7, (index) {
      final day = weekStart.add(Duration(days: index));
      final totalHabits = state.habits.length;
      if (totalHabits == 0) return 0.0;

      final completedHabits = state.habits.where((habit) {
        return habit.completedDates.any((date) =>
            date.year == day.year &&
            date.month == day.month &&
            date.day == day.day);
      }).length;

      return (completedHabits / totalHabits) * 100;
    });

    return data;
  }

  Map<String, double> _getHabitDistribution(HabitState state) {
    if (state.habits.isEmpty) return {};

    final totalHabits = state.habits.length;
    final distribution = <String, int>{};

    for (final habit in state.habits) {
      final completionRate = habit.completedDates.length /
          (DateTime.now().difference(habit.startDate).inDays + 1);

      if (completionRate >= 0.8) {
        distribution['Excellent'] = (distribution['Excellent'] ?? 0) + 1;
      } else if (completionRate >= 0.6) {
        distribution['Good'] = (distribution['Good'] ?? 0) + 1;
      } else if (completionRate >= 0.4) {
        distribution['Fair'] = (distribution['Fair'] ?? 0) + 1;
      } else {
        distribution['Needs Work'] = (distribution['Needs Work'] ?? 0) + 1;
      }
    }

    return distribution
        .map((key, value) => MapEntry(key, (value / totalHabits) * 100));
  }
}

class _TrendsTab extends StatelessWidget {
  final bool isSmallScreen;

  const _TrendsTab({required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildMonthlyTrendsChart(context, state),
            const SizedBox(height: 16),
            _buildStreakAnalysis(context, state),
            const SizedBox(height: 16),
            _buildTimeOfDayAnalysis(context, state),
          ],
        );
      },
    );
  }

  Widget _buildMonthlyTrendsChart(BuildContext context, HabitState state) {
    final theme = Theme.of(context);
    final monthlyData = _getMonthlyCompletionData(state);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Trends',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final month = DateTime.now().subtract(
                            Duration(days: (30 - value.toInt())),
                          );
                          return Text('${month.day}/${month.month}');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}%');
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyData,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakAnalysis(BuildContext context, HabitState state) {
    final theme = Theme.of(context);
    final streakData = _getStreakDistribution(state);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Streak Analysis',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...streakData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value / 100,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.1),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${entry.value.toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOfDayAnalysis(BuildContext context, HabitState state) {
    final theme = Theme.of(context);
    final timeData = _getTimeOfDayDistribution(state);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completion Time Analysis',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const times = [
                            'Morning',
                            'Afternoon',
                            'Evening',
                            'Night'
                          ];
                          return Text(times[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: timeData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: theme.colorScheme.primary,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getMonthlyCompletionData(HabitState state) {
    final now = DateTime.now();
    return List.generate(30, (index) {
      final day = now.subtract(Duration(days: 29 - index));
      final totalHabits = state.habits.length;
      if (totalHabits == 0) return FlSpot(index.toDouble(), 0);

      final completedHabits = state.habits.where((habit) {
        return habit.completedDates.any((date) =>
            date.year == day.year &&
            date.month == day.month &&
            date.day == day.day);
      }).length;

      return FlSpot(
        index.toDouble(),
        (completedHabits / totalHabits) * 100,
      );
    });
  }

  Map<String, double> _getStreakDistribution(HabitState state) {
    if (state.habits.isEmpty) return {};

    final distribution = {
      '1-7 days': 0,
      '8-14 days': 0,
      '15-30 days': 0,
      '30+ days': 0,
    };

    for (final habit in state.habits) {
      if (habit.currentStreak > 30) {
        distribution['30+ days'] = (distribution['30+ days'] ?? 0) + 1;
      } else if (habit.currentStreak > 14) {
        distribution['15-30 days'] = (distribution['15-30 days'] ?? 0) + 1;
      } else if (habit.currentStreak > 7) {
        distribution['8-14 days'] = (distribution['8-14 days'] ?? 0) + 1;
      } else {
        distribution['1-7 days'] = (distribution['1-7 days'] ?? 0) + 1;
      }
    }

    return distribution.map(
        (key, value) => MapEntry(key, (value / state.habits.length) * 100));
  }

  List<double> _getTimeOfDayDistribution(HabitState state) {
    if (state.habits.isEmpty) return List.filled(4, 0.0);

    final distribution = List.filled(4, 0.0);
    var totalCompletions = 0;

    for (final habit in state.habits) {
      for (final date in habit.completedDates) {
        final hour = date.hour;
        if (hour >= 5 && hour < 12) {
          distribution[0] += 1.0;
        } else if (hour >= 12 && hour < 17) {
          distribution[1] += 1.0;
        } else if (hour >= 17 && hour < 22) {
          distribution[2] += 1.0;
        } else {
          distribution[3] += 1.0;
        }
        totalCompletions++;
      }
    }

    if (totalCompletions > 0) {
      return distribution
          .map((count) => (count / totalCompletions) * 100)
          .toList();
    }
    return distribution;
  }
}

class _HabitsTab extends StatelessWidget {
  final bool isSmallScreen;

  const _HabitsTab({required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        if (state.habits.isEmpty) {
          return const Center(
            child: Text('No habits to analyze'),
          );
        }

        final sortedHabits = List.of(state.habits)
          ..sort((a, b) =>
              b.completedDates.length.compareTo(a.completedDates.length));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedHabits.length,
          itemBuilder: (context, index) {
            final habit = sortedHabits[index];
            return _HabitAnalyticsCard(habit: habit);
          },
        );
      },
    );
  }
}

class _HabitAnalyticsCard extends StatelessWidget {
  final Habit habit;

  const _HabitAnalyticsCard({required this.habit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completionRate = _calculateCompletionRate();
    final daysActive = DateTime.now().difference(habit.startDate).inDays + 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              habit.name,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  context,
                  'Completion Rate',
                  '${(completionRate * 100).toStringAsFixed(1)}%',
                ),
                _buildStatItem(
                  context,
                  'Days Active',
                  daysActive.toString(),
                ),
                _buildStatItem(
                  context,
                  'Total XP',
                  habit.xp.toString(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: completionRate,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStreakInfo(
                  context,
                  'Current Streak',
                  habit.currentStreak.toString(),
                ),
                _buildStreakInfo(
                  context,
                  'Longest Streak',
                  habit.longestStreak.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildStreakInfo(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.local_fire_department,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '$value days',
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
      ],
    );
  }

  double _calculateCompletionRate() {
    final daysActive = DateTime.now().difference(habit.startDate).inDays + 1;
    return habit.completedDates.length / daysActive;
  }
}
