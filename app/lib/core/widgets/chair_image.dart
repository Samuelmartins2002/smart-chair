import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Ilustração da cadeira. Hoje é um ícone provisório.
/// Para usar a imagem real, troque o corpo do build por:
///   Image.asset('assets/images/chair.png', height: size, fit: BoxFit.contain)
/// (e declare a pasta assets/images/ no pubspec.yaml)
class ChairImage extends StatelessWidget {
  final double size;
  const ChairImage({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.accessible, size: size * 0.55, color: AppColors.navy),
    );
  }
}