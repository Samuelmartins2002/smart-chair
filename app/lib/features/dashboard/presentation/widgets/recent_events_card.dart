import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/section_card.dart';

class RecentEventsCard extends StatelessWidget {
  const RecentEventsCard({super.key});

  // TODO: trocar por dados reais quando existir o histórico (Etapa 6)
  static const _events = [
    ('14:32', 'Comando de movimento: frente'),
    ('14:30', 'Bateria em 78%'),
    ('14:28', 'Obstáculo detectado (frente)'),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Últimos eventos',
      trailing: TextButton(
        onPressed: () {}, // ligamos ao histórico na Etapa 6
        child: const Text('Ver histórico →'),
      ),
      child: Column(
        children: [
          for (final e in _events)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    child: Text(e.$1,
                        style: const TextStyle(color: AppColors.textMuted)),
                  ),
                  Expanded(
                    child: Text(e.$2,
                        style: const TextStyle(color: AppColors.navy)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}