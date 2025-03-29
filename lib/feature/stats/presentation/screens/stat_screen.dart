import 'dart:math';

import 'package:duration/duration.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/data/models/activity.dart';
import '../../../activity_logs/presentation/providers/activity_logs_provider.dart';
import '../../../home/presentation/providers/activity_provider.dart';
import '../../../home/presentation/widgets/activity_icon_widget.dart';
import '../widgets/date_range_mode_button.dart';
import '../widgets/date_range_panel.dart';

class StatScreen extends StatefulHookConsumerWidget {
  const StatScreen({super.key});

  @override
  ConsumerState<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends ConsumerState<StatScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final List<Activity> activities = ref.watch(activityNotifierProvider);
    final Map<Activity, (Duration, double)> stats =
        ref.watch(activityLogsNotifierProvider(null, null).notifier).getStats();
    useMemoized(() {
      activities.sort(
        (Activity a, Activity b) =>
            (stats[b]?.$2 ?? 0).compareTo(stats[a]?.$2 ?? 0),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: const <DateRangeModeButton>[
          DateRangeModeButton(),
        ],
      ),
      bottomNavigationBar: const DateRangePanel(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: max(MediaQuery.sizeOf(context).height * 0.35, 400),
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (
                    FlTouchEvent event,
                    PieTouchResponse? pieTouchResponse,
                  ) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                startDegreeOffset: 180,
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 1,
                centerSpaceRadius: 0,
                sections: showingSections(stats),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: activities.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int i) {
                  final Activity activity = activities[i];
                  final (Duration, double)? stat = stats[activity];
                  return ActivityStatTile(
                    activity: activity,
                    percentage: stat?.$2 ?? 0,
                    duration: stat?.$1 ?? Duration.zero,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(
    Map<Activity, (Duration, double)> stats,
  ) {
    final List<PieChartSectionData> sections = <PieChartSectionData>[];
    double othersValue = 0;

    // Create sections for normal activities and sum up others in one pass
    for (final Activity activity in stats.keys) {
      final double value = stats[activity]?.$2 ?? 0;
      if (value > 0.01) {
        sections.add(
          PieChartSectionData(
            value: value,
            color: activity.color,
            radius: 150,
            title: '${value.toStringAsFixed(2)}%',
          ),
        );
      } else {
        othersValue += value;
      }
    }

    // Add "Others" section if there's any value
    if (othersValue > 0.01) {
      sections.add(
        PieChartSectionData(
          value: othersValue,
          color: Colors.grey,
          radius: 150,
          title: 'Others\n${othersValue.toStringAsFixed(2)}%',
        ),
      );
    }

    return sections;
  }
}

class ActivityStatTile extends ConsumerWidget {
  const ActivityStatTile({
    required this.activity,
    required this.duration,
    required this.percentage,
    super.key,
  });

  final Activity activity;
  final Duration duration;
  final double percentage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: ActivityIconWidget(
        icon: activity.icon,
        backgroundColor: activity.color,
      ),
      title: Text(activity.name),
      trailing: Text('${percentage.toStringAsFixed(2)}%'),
      subtitle: Text(duration.pretty()),
    );
  }
}
