import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/chair_status.dart';

class ChairStatusCard extends StatelessWidget {
  final ChairStatus status;
  const ChairStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Status da Cadeira',
      trailing: StatusChip(
        label: status.isOnline ? 'Online' : 'Offline',
        positive: status.isOnline,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bateria',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.battery_full, color: AppColors.green),
              const SizedBox(width: 8),
              Text(
                '${status.batteryPercent}%',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: status.batteryPercent / 100,
              minHeight: 8,
              backgroundColor: Colors.blueGrey.shade50,
              color: status.batteryPercent > 20
                  ? AppColors.green
                  : AppColors.red,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Modo de operação',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.settings, size: 18, color: AppColors.navy),
              const SizedBox(width: 6),
              Text(
                status.mode.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}