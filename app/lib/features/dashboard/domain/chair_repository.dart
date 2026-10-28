import 'chair_status.dart';

enum ChairCommand { frente, esquerda, direita, parar }

abstract class ChairRepository {
  Stream<ChairStatus> watchStatus();
  Future<void> sendCommand(ChairCommand command);
}