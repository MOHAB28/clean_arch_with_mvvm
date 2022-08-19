import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../common/state_render/state_render_implementer.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOuputs {
  final StreamController<FlowState> _stateController =
      BehaviorSubject<FlowState>();
  @override
  Sink get inputState => _stateController.sink;

  @override
  Stream<FlowState> get outputState =>
      _stateController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _stateController.close();
  }
}

abstract class BaseViewModelInputs {
  void start();
  void dispose();
  Sink get inputState;
}

abstract class BaseViewModelOuputs {
  Stream<FlowState> get outputState;
}
