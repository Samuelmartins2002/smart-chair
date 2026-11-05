import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/battery_ring.dart';
import '../../../../core/widgets/chair_image.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../domain/chair_status.dart';

class ChairStatusCard extends StatelessWidget {
  final ChairStatus status;
  const ChairStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;

    return SectionCard(
      title: 'Status da Cadeira',
      trailing: StatusChip(
        label: status.isOnline ? 'Online' : 'Offline',
        positive: status.isOnline,
      ),
      child: wide ? _wide() : _narrow(),
    );
  }

  // Web/desktop: imagem à esquerda, dados à direita
  Widget _wide() {
    return Row(
      children: [
        const ChairImage(size: 120),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Label('Bateria'),
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
              _mode(),
            ],
          ),
        ),
      ],
    );
  }

  // Mobile: anel de bateria + modo, imagem embaixo
  Widget _narrow() {
    return Column(
      children: [
        Row(
          children: [
            BatteryRing(percent: status.batteryPercent),
            const SizedBox(width: 20),
            Expanded(child: _mode()),
          ],
        ),
        const SizedBox(height: 16),
        const ChairImage(size: 140),
      ],
    );
  }

  Widget _mode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Label('Modo de operação'),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.settings, size: 18, color: AppColors.navy),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                status.mode.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      );
}