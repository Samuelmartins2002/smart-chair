import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/domain/chair_repository.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import '../../history/presentation/history_controller.dart';

class ControlState {
  final ChairCommand? lastCommand;
  const ControlState({this.lastCommand});
}

class ControlController extends Notifier<ControlState> {
  @override
  ControlState build() => const ControlState();

  Future<void> send(ChairCommand command) async {
    // evita registrar "parar" repetido (ex.: soltar o botão após PARAR)
    final repeated = state.lastCommand == command;
    state = ControlState(lastCommand: command);
    if (!repeated) {
      ref.read(historyProvider.notifier).addCommand(command);
    }
    await ref.read(chairRepositoryProvider).sendCommand(command);
  }

  Future<void> stop() => send(ChairCommand.parar);
}

final controlControllerProvider =
    NotifierProvider<ControlController, ControlState>(ControlController.new);