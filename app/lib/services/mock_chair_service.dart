import 'dart:async';
import 'dart:math';
import '../features/dashboard/domain/chair_repository.dart';
import '../features/dashboard/domain/chair_status.dart';

class MockChairService implements ChairRepository {
  final _rng = Random();

  @override
  Stream<ChairStatus> watchStatus() async* {
    int battery = 78;
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      final obstacle = _rng.nextInt(6) == 0;
      if (_rng.nextInt(10) == 0 && battery > 0) battery--;
      final temp = 21 + _rng.nextInt(3);

      yield ChairStatus(
        batteryPercent: battery,
        mode: ControlMode.gesto,
        state: obstacle ? SystemState.alerta : SystemState.normal,
        obstacleDetected: obstacle,
        obstacleDistanceCm: obstacle ? 20 + _rng.nextDouble() * 30 : null,
        alerts: obstacle ? ['Obstáculo próximo'] : [],
        ipAddress: '192.168.0.123',
        sensors: [
          const SensorReading(
              name: 'MPU-6050', detail: 'Movimento / Direção', active: true),
          const SensorReading(
              name: 'Ultrassônico', detail: 'Detecção de obstáculos', active: true),
          const SensorReading(
              name: 'Hall', detail: 'Rodas / Velocidade', active: true),
          SensorReading(
              name: 'Temperatura',
              detail: 'LM35',
              active: true,
              value: '$temp °C'),
        ],
      );
    }
  }

  @override
  Future<void> sendCommand(ChairCommand command) async {
    // ignore: avoid_print
    print('Comando enviado (mock): ${command.name}');
  }
}