import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/domain/chair_repository.dart';

class DPad extends StatelessWidget {
  final ChairCommand? active;
  final bool interactive; // false = só exibe (aba Gestos)
  final ValueChanged<ChairCommand> onPress;
  final VoidCallback onRelease;
  final VoidCallback onStop;

  const DPad({
    super.key,
    required this.active,
    required this.interactive,
    required this.onPress,
    required this.onRelease,
    required this.onStop,
  });

  static const double cell = 96;

  Widget _dir(ChairCommand c, IconData icon, String label) => _DirButton(
        icon: icon,
        label: label,
        highlighted: active == c,
        interactive: interactive,
        onPress: () => onPress(c),
        onRelease: onRelease,
      );

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(width: cell, height: cell);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            gap,
            _dir(ChairCommand.frente, Icons.arrow_upward, 'Frente'),
            gap,
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dir(ChairCommand.esquerda, Icons.arrow_back, 'Esquerda'),
            _StopButton(onStop: onStop),
            _dir(ChairCommand.direita, Icons.arrow_forward, 'Direita'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            gap,
            _dir(ChairCommand.tras, Icons.arrow_downward, 'Trás'),
            gap,
          ],
        ),
      ],
    );
  }
}

class _DirButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;
  final bool interactive;
  final VoidCallback onPress;
  final VoidCallback onRelease;

  const _DirButton({
    required this.icon,
    required this.label,
    required this.highlighted,
    required this.interactive,
    required this.onPress,
    required this.onRelease,
  });

  @override
  Widget build(BuildContext context) {
    final bg = highlighted ? AppColors.blue : Colors.white;
    final fg = highlighted ? Colors.white : AppColors.navy;

    return SizedBox(
      width: DPad.cell,
      height: DPad.cell,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Listener(
          onPointerDown: interactive ? (_) => onPress() : null,
          onPointerUp: interactive ? (_) => onRelease() : null,
          onPointerCancel: interactive ? (_) => onRelease() : null,
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blueGrey.shade100),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: fg),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  final VoidCallback onStop;
  const _StopButton({required this.onStop});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: DPad.cell,
      height: DPad.cell,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: AppColors.red,
          shape: const CircleBorder(),
          elevation: 4,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onStop,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stop_rounded, size: 36, color: Colors.white),
                Text(
                  'PARAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}