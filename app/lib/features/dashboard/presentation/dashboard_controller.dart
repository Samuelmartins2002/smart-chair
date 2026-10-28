import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/mock_chair_service.dart';
import '../domain/chair_repository.dart';
import '../domain/chair_status.dart';

// Para usar o Pi depois, troque MockChairService por ChairRepositoryImpl
final chairRepositoryProvider = Provider<ChairRepository>((ref) => MockChairService());

final chairStatusProvider = StreamProvider<ChairStatus>((ref) {
  return ref.watch(chairRepositoryProvider).watchStatus();
});