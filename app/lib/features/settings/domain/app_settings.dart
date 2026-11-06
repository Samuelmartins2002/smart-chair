import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String piHost;
  final int piPort;
  final bool notifications;
  final bool batteryAlerts;
  final bool obstacleAlerts;

  const AppSettings({
    this.piHost = '192.168.0.123',
    this.piPort = 8765,
    this.notifications = true,
    this.batteryAlerts = true,
    this.obstacleAlerts = true,
  });

  String get wsUrl => 'ws://$piHost:$piPort';

  AppSettings copyWith({
    String? piHost,
    int? piPort,
    bool? notifications,
    bool? batteryAlerts,
    bool? obstacleAlerts,
  }) =>
      AppSettings(
        piHost: piHost ?? this.piHost,
        piPort: piPort ?? this.piPort,
        notifications: notifications ?? this.notifications,
        batteryAlerts: batteryAlerts ?? this.batteryAlerts,
        obstacleAlerts: obstacleAlerts ?? this.obstacleAlerts,
      );

  @override
  List<Object?> get props =>
      [piHost, piPort, notifications, batteryAlerts, obstacleAlerts];
}