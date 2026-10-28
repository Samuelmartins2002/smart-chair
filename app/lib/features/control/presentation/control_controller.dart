import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/domain/chair_repository.dart';
import '../../dashboard/presentation/dashboard_controller.dart';

class ControlState {
  final ChairCommand? lastCommand;
  const ControlState({this.lastCommand});
}

class ControlController extends Notifier<ControlState> {
  @override
  ControlState build() => const ControlState();

  Future<void> send(ChairCommand command) async {
    state = ControlState(lastCommand: command);
    await ref.read(chairRepositoryProvider).sendCommand(command);
  }

  Future<void> stop() => send(ChairCommand.parar);
}

final controlControllerProvider =
    NotifierProvider<ControlController, ControlState>(ControlController.new);