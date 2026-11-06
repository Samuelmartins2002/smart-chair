import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/section_card.dart';
import '../../dashboard/domain/chair_status.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import '../domain/app_settings.dart';
import 'settings_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final ctrl = ref.read(settingsProvider.notifier);
    final mode = ref.watch(chairStatusProvider).value?.mode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                SectionCard(
                  title: 'Rede',
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Modo simulado (sem Pi)'),
                        subtitle: const Text('Usa dados fictícios no próprio app'),
                        value: s.useMock,
                        onChanged: (v) => ctrl.update((x) => x.copyWith(useMock: v)),
                      ),
                      _InfoRow(
                        icon: Icons.wifi,
                        label: 'Endereço do Pi',
                        value: '${s.piHost}:${s.piPort}',
                        onEdit: () => _editConnection(context, s, ctrl),
                      ),
                      _InfoRow(
                        icon: Icons.key,
                        label: 'Token de pareamento',
                        value: s.piToken.isEmpty ? 'não definido' : '••••',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'Notificações',
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Ativar notificações'),
                        subtitle: const Text(
                            'Alertas de bateria e sensores'),
                        value: s.notifications,
                        onChanged: (v) =>
                            ctrl.update((x) => x.copyWith(notifications: v)),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Bateria baixa'),
                        value: s.batteryAlerts,
                        onChanged: s.notifications
                            ? (v) => ctrl
                                .update((x) => x.copyWith(batteryAlerts: v))
                            : null,
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Obstáculos detectados'),
                        value: s.obstacleAlerts,
                        onChanged: s.notifications
                            ? (v) => ctrl
                                .update((x) => x.copyWith(obstacleAlerts: v))
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'Preferências',
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.settings,
                        label: 'Modo de operação',
                        value: (mode ?? ControlMode.desconhecido).label,
                      ),
                      const _InfoRow(
                        icon: Icons.language,
                        label: 'Idioma',
                        value: 'Português',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const SectionCard(
                  title: 'Sobre',
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.info_outline,
                        label: 'Versão do aplicativo',
                        value: '1.0.0',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editConnection(
    BuildContext context,
    AppSettings current,
    SettingsController ctrl,
  ) async {
    final hostCtrl = TextEditingController(text: current.piHost);
    final portCtrl = TextEditingController(text: '${current.piPort}');
    final tokenCtrl = TextEditingController(text: current.piToken);

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Conexão com o Raspberry Pi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: hostCtrl,
              decoration: const InputDecoration(
                labelText: 'IP ou hostname',
                hintText: '192.168.0.123',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: portCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Porta'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tokenCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Token (opcional)',),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (ok != true) return;
    final host = hostCtrl.text.trim();
    final port = int.tryParse(portCtrl.text.trim());
    if (host.isEmpty || port == null || port < 1 || port > 65535) return;
    await ctrl.update((x) => x.copyWith(piHost: host, piPort: port, piToken: tokenCtrl.text.trim(),));
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.navy),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.navy)),
          ),
          Text(value, style: const TextStyle(color: AppColors.textMuted)),
          if (onEdit != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.edit, size: 18),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}