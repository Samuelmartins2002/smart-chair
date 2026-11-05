import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/section_card.dart';

class GestureLegend extends StatelessWidget {
  const GestureLegend({super.key});

  static const _items = [
    (Icons.touch_app, 'Apontar para cima', 'Frente'),
    (Icons.keyboard_arrow_left, 'Apontar para a esquerda', 'Esquerda'),
    (Icons.keyboard_arrow_right, 'Apontar para a direita', 'Direita'),
    (Icons.pan_tool, 'Mão aberta', 'Parar'),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Gestos reconhecidos',
      child: Column(
        children: [
          for (final i in _items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(i.$1, color: AppColors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(i.$2,
                        style: const TextStyle(color: AppColors.navy)),
                  ),
                  Text(i.$3,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}