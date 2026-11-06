import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum EventType { comando, obstaculo, bateria, modo, estado }

class ChairEvent {
  final DateTime time;
  final EventType type;
  final String title;

  const ChairEvent({
    required this.time,
    required this.type,
    required this.title,
  });

  IconData get icon => switch (type) {
        EventType.comando => Icons.open_with,
        EventType.obstaculo => Icons.warning_amber_rounded,
        EventType.bateria => Icons.battery_alert,
        EventType.modo => Icons.swap_horiz,
        EventType.estado => Icons.info_outline,
      };

  Color get color => switch (type) {
        EventType.comando => AppColors.blue,
        EventType.obstaculo => AppColors.red,
        EventType.bateria => Colors.orange,
        EventType.modo => AppColors.purple,
        EventType.estado => AppColors.navyLight,
      };

  String get hhmm =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}