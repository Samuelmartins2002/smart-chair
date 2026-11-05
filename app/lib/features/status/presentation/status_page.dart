import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/battery_ring.dart';
import '../../../core/widgets/section_card.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import 'battery_history_controller.dart';
import 'widgets/battery_chart.dart';
import 'widgets/sensor_tile.dart';

class StatusPage extends ConsumerWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(chairStatusProvider);
    final history = ref.watch(batteryHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Status dos Sensores',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: status.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (s) {
          final width = MediaQuery.sizeOf(context).width;
          final columns = width < 480 ? 1 : 2;
          const spacing = 12.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, c) {
                    final w = (c.maxWidth - spacing * (columns - 1)) / columns;
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (final sensor in s.sensors)
                          SizedBox(width: w, child: SensorTile(sensor: sensor)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'Nível da Bateria',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BatteryRing(percent: s.batteryPercent, size: 88),
                          const SizedBox(width: 16),
                          Expanded(
                            child: BatteryChart(samples: history),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Atualizado em tempo real',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}