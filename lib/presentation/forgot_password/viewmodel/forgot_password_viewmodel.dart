import 'dart:async';

import 'package:advanced_clean_architecture_with_mvvm/app/functions.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/usecase/forgot_password_usecase.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/base/base_view_model.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/common/state_renderer/state_renderer_impl.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();

  // .. forgot password use case
  final ForgotPasswordUsecase _forgotPasswordUsecase;
  ForgotPasswordViewModel(this._forgotPasswordUsecase);

  var email = '';

  // .. INPUTS
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUsecase.execute(email)).fold(
      (failure) => {
        inputState
            .add(ErrorState(StateRendererType.popupErrorState, failure.message))
      },
      (supportMessage) => {
        inputState.add(
          SuccessState(supportMessage),
        )
      },
    );
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  // .. OUTPUTS
  @override
  Stream<bool> get outputIsAllInputValid =>
      _isAllInputValidStreamController.stream
          .map((event) => isEmailValid(email));
  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((event) => _isAllInputValid());

  _isAllInputValid() {
    return isEmailValid(email);
  }

  _validate() {
    inputIsAllInputValid.add(null);
  }
}

abstract mixin class ForgotPasswordViewModelInputs {
  forgotPassword();
  setEmail(String email);
  Sink get inputEmail;
  Sink get inputIsAllInputValid;
}

abstract mixin class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputIsEmailValid;
  Stream<bool> get outputIsAllInputValid;
}
