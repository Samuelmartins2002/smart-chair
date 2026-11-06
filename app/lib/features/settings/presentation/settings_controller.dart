import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/app_settings.dart';

class SettingsController extends Notifier<AppSettings> {
  late SharedPreferences _prefs;

  @override
  AppSettings build() {
    _load();
    return const AppSettings();
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    const d = AppSettings();
    state = AppSettings(
      piHost: _prefs.getString('piHost') ?? d.piHost,
      piPort: _prefs.getInt('piPort') ?? d.piPort,
      notifications: _prefs.getBool('notifications') ?? d.notifications,
      batteryAlerts: _prefs.getBool('batteryAlerts') ?? d.batteryAlerts,
      obstacleAlerts: _prefs.getBool('obstacleAlerts') ?? d.obstacleAlerts,
      piToken: _prefs.getString('piToken') ?? d.piToken,
      useMock: _prefs.getBool('useMock') ?? d.useMock,
    );
  }

  Future<void> _save() async {
    await _prefs.setString('piHost', state.piHost);
    await _prefs.setInt('piPort', state.piPort);
    await _prefs.setBool('notifications', state.notifications);
    await _prefs.setBool('batteryAlerts', state.batteryAlerts);
    await _prefs.setBool('obstacleAlerts', state.obstacleAlerts);
    await _prefs.setString('piToken', state.piToken);
    await _prefs.setBool('useMock', state.useMock);
  }

  Future<void> update(AppSettings Function(AppSettings s) change) async {
    state = change(state);
    await _save();
  }
}

final settingsProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);