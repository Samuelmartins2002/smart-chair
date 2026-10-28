import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_controller.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(chairStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Chair')),
      body: status.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (s) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(child: ListTile(
              leading: const Icon(Icons.battery_full),
              title: const Text('Bateria'),
              trailing: Text('${s.batteryPercent}%'),
            )),
            Card(child: ListTile(
              leading: const Icon(Icons.pan_tool),
              title: const Text('Modo'),
              trailing: Text(s.mode.name.toUpperCase()),
            )),
            Card(child: ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text('Obstáculos'),
              trailing: Text(s.obstacleDetected ? 'DETECTADO' : 'LIVRE'),
            )),
            Card(child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Estado'),
              trailing: Text(s.state.name.toUpperCase()),
            )),
            for (final a in s.alerts)
              Card(
                color: Colors.red.shade100,
                child: ListTile(leading: const Icon(Icons.warning), title: Text(a)),
              ),
          ],
        ),
      ),
    );
  }
}