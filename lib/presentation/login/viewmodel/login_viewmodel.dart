import 'dart:async';

import 'package:advanced_clean_architecture_with_mvvm/domain/usecase/login_usecase.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/base/base_view_model.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/common/freezed_data_classes.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/common/state_renderer/state_renderer_impl.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  // .. stream controller has one listener
  // .. if we need to have many listeners we will use .broadcast
  // ..
  final StreamController _usernameSC = StreamController<String>.broadcast();
  final StreamController _passwordSC = StreamController<String>.broadcast();

  // .. for login button
  final StreamController _areAllInputsValidSC =
      StreamController<void>.broadcast();

  // .. stream controller for user logged in successfully
  final StreamController isUserLoggedInSuccessfullySC = StreamController();

  // .. instance of LoginObject
  var loginObject = LoginObject("", "");

  final LoginUseCase _loginUseCase;
  LoginViewModel(this._loginUseCase);

  // .. INPUTS

  @override
  void dispose() {
    super.dispose();
    _usernameSC.close();
    _passwordSC.close();
    _areAllInputsValidSC.close();
    isUserLoggedInSuccessfullySC.close();
  }

  @override
  void start() {
    // ..
    inputState.add(ContentState());
  }

  @override
  Sink get inputUsername => _usernameSC.sink;

  @override
  Sink get inputPassword => _passwordSC.sink;

  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidSC.sink;

  @override
  Future<void> login() async {
    // .. show loading dialog
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));

    // ..
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.username, loginObject.password)))
        .fold(
      (failure) => {
        // .. failure
        inputState
            .add(ErrorState(StateRendererType.popupErrorState, failure.message))
      },
      (data) {
        // .. content
        inputState.add(ContentState());

        // .. nav to main screen
        isUserLoggedInSuccessfullySC.add(true);
      },
    );
  }

  @override
  void setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllInputsValid.add(null);
  }

  @override
  void setUsername(String username) {
    inputUsername.add(username);
    loginObject = loginObject.copyWith(username: username);
    inputAreAllInputsValid.add(null);
  }

  // .. OUTPUTS
  @override
  Stream<bool> get outIsUsernameValid =>
      // .. note the value of event is String value
      // .. the type of the StreamController is bool
      // .. _isUsernameValid take a string and return a bool
      _usernameSC.stream.map((event) => _isUsernameValid(event));

  @override
  Stream<bool> get outIsPasswordValid =>
      _passwordSC.stream.map((event) => _isPasswordValid(event));

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputsValidSC.stream.map((_) => _areAllInputsValid());

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUsernameValid(String username) {
    return username.isNotEmpty;
  }

  bool _areAllInputsValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUsernameValid(loginObject.username);
  }
}

abstract mixin class LoginViewModelInputs {
  void setUsername(String username);
  void setPassword(String password);
  Future<void> login();

  // .. inputs sinks
  Sink get inputUsername;
  Sink get inputPassword;
  Sink get inputAreAllInputsValid;
}

abstract mixin class LoginViewModelOutputs {
  // .. Streams outputs
  Stream<bool> get outIsUsernameValid;
  Stream<bool> get outIsPasswordValid;
  Stream<bool> get outAreAllInputsValid;
}
