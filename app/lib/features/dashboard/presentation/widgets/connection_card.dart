import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../settings/presentation/settings_controller.dart';
import '../../domain/chair_status.dart';

class ConnectionCard extends ConsumerWidget {
  final ChairStatus status;
  const ConnectionCard({super.key, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useMock = ref.watch(settingsProvider.select((s) => s.useMock));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              useMock ? Icons.science_outlined : Icons.wifi,
              size: 32,
              color: useMock ? AppColors.purple : AppColors.navy,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Conexão',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.navy)),
                  Text(
                    useMock ? 'Modo simulado (sem Pi)' : 'Wi-Fi (Raspberry Pi)',
                    style: TextStyle(
                      color: useMock ? AppColors.purple : AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    status.ipAddress.isEmpty ? '—' : status.ipAddress,
                    style: const TextStyle(color: AppColors.navy),
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