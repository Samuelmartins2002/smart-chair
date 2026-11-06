import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String piHost;
  final int piPort;
  final String piToken;
  final bool useMock;
  final bool notifications;
  final bool batteryAlerts;
  final bool obstacleAlerts;

  const AppSettings({
    this.piHost = 'localhost',
    this.piPort = 8765,
    this.piToken = '',
    this.useMock = true,
    this.notifications = true,
    this.batteryAlerts = true,
    this.obstacleAlerts = true,
  });

  String get wsUrl => 'ws://$piHost:$piPort';

  AppSettings copyWith({
    String? piHost,
    int? piPort,
    String? piToken,
    bool? useMock,
    bool? notifications,
    bool? batteryAlerts,
    bool? obstacleAlerts,
  }) =>
      AppSettings(
        piHost: piHost ?? this.piHost,
        piPort: piPort ?? this.piPort,
        piToken: piToken ?? this.piToken,
        useMock: useMock ?? this.useMock,
        notifications: notifications ?? this.notifications,
        batteryAlerts: batteryAlerts ?? this.batteryAlerts,
        obstacleAlerts: obstacleAlerts ?? this.obstacleAlerts,
      );

  @override
  List<Object?> get props => [
        piHost, piPort, piToken, useMock,
        notifications, batteryAlerts, obstacleAlerts,
      ];
}