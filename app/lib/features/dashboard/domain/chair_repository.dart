import 'chair_status.dart';

enum ChairCommand { frente, tras, esquerda, direita, parar }

abstract class ChairRepository {
  Stream<ChairStatus> watchStatus();
  Future<void> sendCommand(ChairCommand command);
}