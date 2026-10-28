import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/chair_status.dart';

class SensorsCard extends StatelessWidget {
  final List<SensorReading> sensors;
  const SensorsCard({super.key, required this.sensors});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Sensores',
      child: Column(
        children: [
          for (final s in sensors)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      s.name,
                      style: const TextStyle(color: AppColors.navy),
                    ),
                  ),
                  if (s.value != null)
                    Text(
                      s.value!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    )
                  else
                    StatusChip(
                      label: s.active ? 'Ativo' : 'Inativo',
                      positive: s.active,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}