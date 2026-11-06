import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/presentation/dashboard_controller.dart';

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
    ref.listen(chairStatusProvider, (_, next) {
      next.whenData((s) {
          if(!s.isOnline) return;
        });
    });
    return [];
  }
}

final batteryHistoryProvider =
    NotifierProvider<BatteryHistoryController, List<BatterySample>>(
  BatteryHistoryController.new,
);