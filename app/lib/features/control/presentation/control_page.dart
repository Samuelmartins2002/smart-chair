import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/domain/chair_repository.dart';
import 'control_controller.dart';
import 'widgets/dpad.dart';
import 'widgets/gesture_legend.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Controle',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [Tab(text: 'Gestos'), Tab(text: 'Toque')],
          ),
        ),
        body: const TabBarView(
          // evita que arrastar o dedo troque de aba durante o controle
          physics: NeverScrollableScrollPhysics(),
          children: [
            _ControlTab(interactive: false),
            _ControlTab(interactive: true),
          ],
        ),
      ),
    );
  }
}

class _ControlTab extends ConsumerWidget {
  final bool interactive;
  const _ControlTab({required this.interactive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(controlControllerProvider.notifier);
    final last = ref.watch(controlControllerProvider).lastCommand;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              _LastCommandChip(last: last),
              const SizedBox(height: 24),
              DPad(
                active: last == ChairCommand.parar ? null : last,
                interactive: interactive,
                onPress: controller.send,
                onRelease: controller.stop,
                onStop: controller.stop,
              ),
              const SizedBox(height: 24),
              Text(
                interactive
                    ? 'Segure um botão para mover. Ao soltar, a cadeira para.'
                    : 'Mova a mão conforme a direção desejada.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted),
              ),
              if (!interactive) ...[
                const SizedBox(height: 20),
                const GestureLegend(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LastCommandChip extends StatelessWidget {
  final ChairCommand? last;
  const _LastCommandChip({required this.last});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Text(
        'Último comando: ${last?.name.toUpperCase() ?? '—'}',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
    );
  }
}