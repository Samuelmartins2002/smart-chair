import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../features/dashboard/domain/chair_repository.dart';
import '../features/dashboard/domain/chair_status.dart';

class WebSocketChairService implements ChairRepository {
  final String url;
  final String token;

  WebSocketChairService({required this.url, this.token = ''});

  static const _resendEvery = Duration(milliseconds: 150);
  static const _retryAfter = Duration(seconds: 2);

  WebSocketChannel? _channel;
  Timer? _resendTimer;
  bool _disposed = false;

  @override
  Stream<ChairStatus> watchStatus() async* {
    while (!_disposed) {
      WebSocketChannel? channel;
      try {
        channel = WebSocketChannel.connect(Uri.parse(url));
        await channel.ready.timeout(const Duration(seconds: 5));
        channel.sink.add(jsonEncode({'type': 'hello', 'token': token}));
        _channel = channel;

        await for (final raw in channel.stream) {
          final msg = jsonDecode(raw as String) as Map<String, dynamic>;
          switch (msg['type']) {
            case 'status':
              yield ChairStatus.fromJson(msg);
            case 'error':
              throw StateError('Servidor recusou: ${msg['reason']}');
          }
        }
      } catch (e) {
        // ignore: avoid_print
        print('WebSocket: $e');
      } finally {
        _channel = null;
        _stopResend();
        channel?.sink.close();
      }

      if (_disposed) return;
      yield const ChairStatus.disconnected();
      await Future.delayed(_retryAfter);
    }
  }

  @override
  Future<void> sendCommand(ChairCommand command) async {
    _stopResend();
    _send(command);
    if (command != ChairCommand.parar) {
      // O Pi para sozinho se parar de receber (watchdog)
      _resendTimer = Timer.periodic(_resendEvery, (_) => _send(command));
    }
  }

  void _send(ChairCommand c) {
    _channel?.sink.add(jsonEncode({'type': 'command', 'value': c.name}));
  }

  void _stopResend() {
    _resendTimer?.cancel();
    _resendTimer = null;
  }

  void dispose() {
    _disposed = true;
    _stopResend();
    _channel?.sink.close();
  }
}