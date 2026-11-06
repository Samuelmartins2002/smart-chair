import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/domain/chair_repository.dart';
import '../../dashboard/domain/chair_status.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import '../domain/chair_event.dart';

class HistoryController extends Notifier<List<ChairEvent>> {
  static const maxEvents = 200;
  static const lowBattery = 20;

  ChairStatus? _prev;

  @override
  List<ChairEvent> build() {
    ref.listen(chairStatusProvider, (_, next) {
      next.whenData(_onStatus);
    });
    return [];
  }

  void _onStatus(ChairStatus s) {
    final p = _prev;
    _prev = s;
    if (p == null) return;

    if (s.obstacleDetected && !p.obstacleDetected) {
      final d = s.obstacleDistanceCm;
      add(EventType.obstaculo,
          'Obstáculo detectado${d != null ? ' a ${d.round()} cm' : ''}');
    }
    if (s.batteryPercent <= lowBattery && p.batteryPercent > lowBattery) {
      add(EventType.bateria, 'Bateria baixa (${s.batteryPercent}%)');
    }
    if (s.mode != p.mode) {
      add(EventType.modo, 'Modo alterado para ${s.mode.label}');
    }
    if (s.state != p.state && s.state != SystemState.alerta) {
      add(EventType.estado, 'Estado: ${s.state.name}');
    }
  }

  void addCommand(ChairCommand c) {
    const labels = {
      ChairCommand.frente: 'frente',
      ChairCommand.tras: 'trás',
      ChairCommand.esquerda: 'esquerda',
      ChairCommand.direita: 'direita',
      ChairCommand.parar: 'parar',
    };
    add(EventType.comando, 'Comando de movimento: ${labels[c]}');
  }

  void add(EventType type, String title) {
    final updated = [
      ChairEvent(time: DateTime.now(), type: type, title: title),
      ...state,
    ];
    state = updated.length > maxEvents
        ? updated.sublist(0, maxEvents)
        : updated;
  }

  void clear() => state = [];
}

final historyProvider =
    NotifierProvider<HistoryController, List<ChairEvent>>(
  HistoryController.new,
);