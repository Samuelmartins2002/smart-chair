import 'package:equatable/equatable.dart';

enum ControlMode { gesto, voz, app, desconhecido }
enum SystemState { normal, alerta, emergencia, desconectado }

class ChairStatus extends Equatable {
  final int batteryPercent;
  final ControlMode mode;
  final SystemState state;
  final bool obstacleDetected;
  final double? obstacleDistanceCm;
  final List<String> alerts;

  const ChairStatus({
    required this.batteryPercent,
    required this.mode,
    required this.state,
    required this.obstacleDetected,
    this.obstacleDistanceCm,
    this.alerts = const [],
  });

  const ChairStatus.disconnected()
      : batteryPercent = 0,
        mode = ControlMode.desconhecido,
        state = SystemState.desconectado,
        obstacleDetected = false,
        obstacleDistanceCm = null,
        alerts = const [];

  factory ChairStatus.fromJson(Map<String, dynamic> json) => ChairStatus(
        batteryPercent: json['battery'] as int,
        mode: ControlMode.values.byName(json['mode'] as String),
        state: SystemState.values.byName(json['state'] as String),
        obstacleDetected: json['obstacle'] as bool,
        obstacleDistanceCm: (json['obstacle_distance_cm'] as num?)?.toDouble(),
        alerts: List<String>.from(json['alerts'] ?? []),
      );

  @override
  List<Object?> get props =>
      [batteryPercent, mode, state, obstacleDetected, obstacleDistanceCm, alerts];
}