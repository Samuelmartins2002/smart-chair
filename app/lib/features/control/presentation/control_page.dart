import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/domain/chair_repository.dart';
import 'control_controller.dart';

class ControlPage extends ConsumerWidget {
  const ControlPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(controlControllerProvider.notifier);
    final last = ref.watch(controlControllerProvider).lastCommand;

    return Scaffold(
      appBar: AppBar(title: const Text('Controle')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Último comando: ${last?.name.toUpperCase() ?? '—'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              _HoldButton(
                icon: Icons.arrow_upward,
                label: 'FRENTE',
                onPress: () => controller.send(ChairCommand.frente),
                onRelease: controller.stop,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _HoldButton(
                    icon: Icons.arrow_back,
                    label: 'ESQUERDA',
                    onPress: () => controller.send(ChairCommand.esquerda),
                    onRelease: controller.stop,
                  ),
                  const SizedBox(width: 12),
                  _HoldButton(
                    icon: Icons.arrow_forward,
                    label: 'DIREITA',
                    onPress: () => controller.send(ChairCommand.direita),
                    onRelease: controller.stop,
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                  ),
                  onPressed: controller.stop,
                  icon: const Icon(Icons.stop_circle, size: 36),
                  label: const Text(
                    'PARAR',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoldButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPress;
  final VoidCallback onRelease;

  const _HoldButton({
    required this.icon,
    required this.label,
    required this.onPress,
    required this.onRelease,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => onPress(),
      onPointerUp: (_) => onRelease(),
      onPointerCancel: (_) => onRelease(),
      child: Container(
        width: 140,
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}