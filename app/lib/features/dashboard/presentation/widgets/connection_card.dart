import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/chair_status.dart';

class ConnectionCard extends StatelessWidget {
  final ChairStatus status;
  const ConnectionCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.wifi, size: 32, color: AppColors.navy),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Conexão',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.navy)),
                const Text('Wi-Fi',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                Text(
                  status.ipAddress.isEmpty ? '—' : status.ipAddress,
                  style: const TextStyle(color: AppColors.navy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}