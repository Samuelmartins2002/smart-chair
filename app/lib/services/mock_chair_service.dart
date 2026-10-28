import 'dart:async';
import 'dart:math';
import '../features/dashboard/domain/chair_repository.dart';
import '../features/dashboard/domain/chair_status.dart';

class MockChairService implements ChairRepository {
  final _rng = Random();

  @override
  Stream<ChairStatus> watchStatus() async* {
    int battery = 85;
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final obstacle = _rng.nextInt(6) == 0;
      if (_rng.nextInt(10) == 0 && battery > 0) battery--;
      yield ChairStatus(
        batteryPercent: battery,
        mode: ControlMode.gesto,
        state: obstacle ? SystemState.alerta : SystemState.normal,
        obstacleDetected: obstacle,
        obstacleDistanceCm: obstacle ? 20 + _rng.nextDouble() * 30 : null,
        alerts: obstacle ? ['Obstáculo próximo'] : [],
      );
    }
  }

  @override
  Future<void> sendCommand(ChairCommand command) async {
    // ignore: avoid_print
    print('Comando enviado (mock): ${command.name}');
  }
}