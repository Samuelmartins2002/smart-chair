import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/action_title.dart';
import '../domain/chair_status.dart';
import 'dashboard_controller.dart';
import 'widgets/chair_status_card.dart';
import 'widgets/connection_card.dart';
import 'widgets/recent_events_card.dart';
import 'widgets/sensors_card.dart';
import '../../status/presentation/battery_history_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(chairStatusProvider);

    ref.watch(batteryHistoryProvider);

    return Scaffold(
      body: SafeArea(
        child: status.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erro: $e')),
          data: (s) => _Content(status: s),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final ChairStatus status;
  const _Content({required this.status});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 800;

    final statusCard = ChairStatusCard(status: status);
    final sensorsCard = SensorsCard(sensors: status.sensors);
    final connectionCard = ConnectionCard(status: status);
    final events = const RecentEventsCard();

    final controlTile = ActionTile(
      icon: Icons.open_with,
      title: 'Controle',
      subtitle: 'Movimente a cadeira com gestos ou toque.',
      color: AppColors.blue,
      onTap: () => context.go('/control'),
    );
    final voiceTile = ActionTile(
      icon: Icons.mic,
      title: 'Assistente de Voz',
      subtitle: 'Fale com a Smart Chair.',
      color: AppColors.purple,
      onTap: () => context.go('/voice'),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          const SizedBox(height: 20),
          if (wide) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: statusCard),
                const SizedBox(width: 16),
                Expanded(child: sensorsCard),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: controlTile),
                const SizedBox(width: 16),
                Expanded(child: voiceTile),
                const SizedBox(width: 16),
                Expanded(child: connectionCard),
              ],
            ),
          ] else ...[
            statusCard,
            const SizedBox(height: 16),
            sensorsCard,
            const SizedBox(height: 16),
            controlTile,
            const SizedBox(height: 12),
            voiceTile,
            const SizedBox(height: 16),
            connectionCard,
          ],
          const SizedBox(height: 16),
          events,
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, Usuário!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Bem-vindo de volta ao seu Smart Chair.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: AppColors.navy),
        ),
      ],
    );
  }
}