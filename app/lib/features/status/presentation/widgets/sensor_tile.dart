import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../dashboard/domain/chair_status.dart';

class SensorTile extends StatelessWidget {
  final SensorReading sensor;
  const SensorTile({super.key, required this.sensor});

  IconData get _icon {
    final n = sensor.name.toLowerCase();
    if (n.contains('mpu')) return Icons.explore;
    if (n.contains('ultra')) return Icons.sensors;
    if (n.contains('hall')) return Icons.settings_input_antenna;
    if (n.contains('temp')) return Icons.thermostat;
    return Icons.memory;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(_icon, size: 28, color: AppColors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sensor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    sensor.detail,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (sensor.value != null)
                    Text(
                      sensor.value!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    )
                  else
                    StatusChip(
                      label: sensor.active ? 'Ativo' : 'Inativo',
                      positive: sensor.active,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}