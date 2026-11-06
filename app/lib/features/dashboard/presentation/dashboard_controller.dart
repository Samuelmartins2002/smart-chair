import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_chair_service.dart';
import '../../../services/websocket_service.dart';
import '../../settings/presentation/settings_controller.dart';
import '../domain/chair_repository.dart';
import '../domain/chair_status.dart';

final chairRepositoryProvider = Provider<ChairRepository>((ref) {
  // select: só recria a conexão se estes 3 valores mudarem
  final cfg = ref.watch(
    settingsProvider.select((s) => (s.useMock, s.wsUrl, s.piToken)),
  );
  if (cfg.$1) return MockChairService();

  final service = WebSocketChairService(url: cfg.$2, token: cfg.$3);
  ref.onDispose(service.dispose);
  return service;
});

final chairStatusProvider = StreamProvider<ChairStatus>((ref) {
  return ref.watch(chairRepositoryProvider).watchStatus();
});