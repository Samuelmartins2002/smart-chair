import 'package:equatable/equatable.dart';

enum ControlMode { gesto, voz, app, desconhecido }
enum SystemState { normal, alerta, emergencia, desconectado }

extension ControlModeLabel on ControlMode {
  String get label => switch (this) {
        ControlMode.gesto => 'Manual (Gestos)',
        ControlMode.voz => 'Voz',
        ControlMode.app => 'Aplicativo',
        ControlMode.desconhecido => '—',
      };
}

class SensorReading extends Equatable {
  final String name;    // ex.: "MPU-6050"
  final String detail;  // ex.: "Movimento / Direção"
  final bool active;
  final String? value;  // ex.: "22 °C" (opcional)

  const SensorReading({
    required this.name,
    required this.detail,
    required this.active,
    this.value,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) => SensorReading(
        name: json['name'] as String,
        detail: (json['detail'] ?? '') as String,
        active: json['active'] as bool,
        value: json['value']?.toString(),
      );

  @override
  List<Object?> get props => [name, detail, active, value];
}

class ChairStatus extends Equatable {
  final int batteryPercent;
  final ControlMode mode;
  final SystemState state;
  final bool obstacleDetected;
  final double? obstacleDistanceCm;
  final List<String> alerts;
  final List<SensorReading> sensors;
  final String ipAddress;

  const ChairStatus({
    required this.batteryPercent,
    required this.mode,
    required this.state,
    required this.obstacleDetected,
    this.obstacleDistanceCm,
    this.alerts = const [],
    this.sensors = const [],
    this.ipAddress = '',
  });

  const ChairStatus.disconnected()
      : batteryPercent = 0,
        mode = ControlMode.desconhecido,
        state = SystemState.desconectado,
        obstacleDetected = false,
        obstacleDistanceCm = null,
        alerts = const [],
        sensors = const [],
        ipAddress = '';

  bool get isOnline => state != SystemState.desconectado;

  factory ChairStatus.fromJson(Map<String, dynamic> json) => ChairStatus(
        batteryPercent: json['battery'] as int,
        mode: ControlMode.values.byName(json['mode'] as String),
        state: SystemState.values.byName(json['state'] as String),
        obstacleDetected: json['obstacle'] as bool,
        obstacleDistanceCm: (json['obstacle_distance_cm'] as num?)?.toDouble(),
        alerts: List<String>.from(json['alerts'] ?? []),
        sensors: (json['sensors'] as List? ?? [])
            .map((e) => SensorReading.fromJson(e as Map<String, dynamic>))
            .toList(),
        ipAddress: (json['ip'] ?? '') as String,
      );

  @override
  List<Object?> get props => [
        batteryPercent, mode, state, obstacleDetected,
        obstacleDistanceCm, alerts, sensors, ipAddress,
      ];
}