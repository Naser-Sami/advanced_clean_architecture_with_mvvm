import 'dart:async';

import 'package:advanced_clean_architecture_with_mvvm/presentation/common/state_renderer/state_renderer_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  // shared variables and functions that
  //  will be used through any view model

  final StreamController _inputStreamController = StreamController.broadcast();

  @override
  Sink get inputState => _inputStreamController.sink;

  @override
  Stream<FlowState> get outputState =>
      _inputStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStreamController.close();
  }
}

abstract mixin class BaseViewModelInputs {
  // .. start view life cycle
  void start(); // ... start view model job

  // .. finish view life cycle
  void dispose(); // ... called when view model died

  Sink get inputState;
}

abstract mixin class BaseViewModelOutputs {
  // ..
  Stream<FlowState> get outputState;
}
