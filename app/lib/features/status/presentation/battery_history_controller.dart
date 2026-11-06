import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import '../../dashboard/domain/chair_status.dart';

class BatterySample {
  final DateTime time;
  final int percent;
  const BatterySample(this.time, this.percent);
}

/// Acumula as leituras de bateria vindas do stream (máx. 60 amostras).
class BatteryHistoryController extends Notifier<List<BatterySample>> {
  static const maxSamples = 60;

  @override
  List<BatterySample> build() {
    void add(ChairStatus s) {
      if (!s.isOnline) return; // não registra leitura quando desconectado
      final updated = [...state, BatterySample(DateTime.now(), s.batteryPercent)];
      state = updated.length > maxSamples
          ? updated.sublist(updated.length - maxSamples)
          : updated;
    }

    // leituras futuras
    ref.listen(chairStatusProvider, (_, next) => next.whenData(add));

    // leitura que já existia quando o provider foi criado
    final current = ref.read(chairStatusProvider).value;
    if (current != null && current.isOnline) {
      return [BatterySample(DateTime.now(), current.batteryPercent)];
    }
    return [];
    }
  }

final batteryHistoryProvider =
    NotifierProvider<BatteryHistoryController, List<BatterySample>>(
  BatteryHistoryController.new,
);