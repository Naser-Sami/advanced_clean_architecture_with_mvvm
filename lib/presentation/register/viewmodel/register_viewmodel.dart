import 'dart:async';
import 'dart:io';

import 'package:advanced_clean_architecture_with_mvvm/app/functions.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/usecase/register_usecase.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/base/base_view_model.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/common/freezed_data_classes.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/strings_manager.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInputs, RegisterViewModelOutputs {
  // .. controllers
  // .. of type string
  final StreamController _usernameSC = StreamController<String>.broadcast();
  final StreamController _mobileNumberSC = StreamController<String>.broadcast();
  final StreamController _emailSC = StreamController<String>.broadcast();
  final StreamController _passwordSC = StreamController<String>.broadcast();
  // .. of type File
  final StreamController _profilePictureSC = StreamController<File>.broadcast();
  // .. of type void
  final StreamController _areAllInputsValidSC =
      StreamController<void>.broadcast();

  var registerObject = RegisterObject("", "", "", "", "", "");

  final RegisterUseCase _registerUseCase;
  RegisterViewModel(this._registerUseCase);

  @override
  void start() {
    // TODO: implement start
  }

  @override
  void dispose() {
    _usernameSC.close();
    _mobileNumberSC.close();
    _emailSC.close();
    _passwordSC.close();
    _profilePictureSC.close();
    _areAllInputsValidSC.close();
    super.dispose();
  }

  // ..
  // .. INPUTS
  // ..

  @override
  Sink get inputEmail => _emailSC.sink;

  @override
  Sink get inputMobileNumber => _mobileNumberSC.sink;

  @override
  Sink get inputPassword => _passwordSC.sink;

  @override
  Sink get inputProfilePicture => _profilePictureSC.sink;

  @override
  Sink get inputUsername => _usernameSC.sink;

  // ..
  // .. OUTPUTS
  // ..

  // .. user name
  @override
  Stream<bool> get outputIsUsernameValid =>
      _usernameSC.stream.map((username) => _isUsernameValid(username));

  @override
  Stream<String?> get outputErrorUsername => outputIsUsernameValid.map(
      (isUsernameValid) => isUsernameValid ? null : AppStrings.userNameInvalid);

  // .. email
  @override
  Stream<bool> get outputIsEmailValid =>
      _emailSC.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : AppStrings.invalidEmail);

  // .. mobile number
  @override
  Stream<bool> get outputIsMobileNumberValid => _mobileNumberSC.stream
      .map((mobilNumber) => _isMobileNumberValid(mobilNumber));

  @override
  Stream<String?> get outputErrorMobileNumber =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : AppStrings.mobileNumberInvalid);

  // .. password
  @override
  Stream<bool> get outputIsPasswordValid =>
      _passwordSC.stream.map((password) => _isPasswordValid(password));

  @override
  Stream<String?> get outputErrorPassword => outputIsPasswordValid.map(
      (isPasswordValid) => isPasswordValid ? null : AppStrings.passwordInvalid);

  // .. profile picture
  @override
  Stream<File> get outputIsProfilePictureValid =>
      _profilePictureSC.stream.map((file) => file);

  // ..
  // .. private function
  // ..
  bool _isUsernameValid(String username) {
    return username.length >= 8;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _areAllInputsValid() {
    return registerObject.email.isNotEmpty &&
        registerObject.userName.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty &&
        registerObject.countryMobileCode.isNotEmpty;
  }

  validate() {
    inputAllInputsValid.add(null);
  }

  // .. end private functions

  @override
  register() {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }

    validate();
  }

  @override
  setEmail(String email) {
    if (isEmailValid(email)) {
      registerObject = registerObject.copyWith(email: email);
    } else {
      registerObject = registerObject.copyWith(email: "");
    }

    validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    if (_isMobileNumberValid(mobileNumber)) {
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      registerObject = registerObject.copyWith(mobileNumber: "");
    }

    validate();
  }

  @override
  setPassword(String password) {
    if (_isPasswordValid(password)) {
      registerObject = registerObject.copyWith(password: password);
    } else {
      registerObject = registerObject.copyWith(password: "");
    }

    validate();
  }

  @override
  setProfilePicture(File profilePicture) {
    if (profilePicture.path.isNotEmpty) {
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      registerObject = registerObject.copyWith(profilePicture: "");
    }

    validate();
  }

  @override
  setUsername(String username) {
    if (_isUsernameValid(username)) {
      // .. update register view object

      registerObject = registerObject.copyWith(userName: username);
    } else {
      // .. reset user name value in register view object

      registerObject = registerObject.copyWith(userName: "");
    }

    validate();
  }

  @override
  Sink get inputAllInputsValid => _areAllInputsValidSC.sink;

  @override
  Stream<bool> get outputAreAllInputsValid =>
      _areAllInputsValidSC.stream.map((_) => _areAllInputsValid());
}

abstract mixin class RegisterViewModelInputs {
  Sink get inputUsername;
  Sink get inputMobileNumber;
  Sink get inputEmail;
  Sink get inputPassword;
  Sink get inputProfilePicture;
  Sink get inputAllInputsValid;

  register();

  setUsername(String username);
  setMobileNumber(String mobileNumber);
  setCountryCode(String countryCode);
  setEmail(String email);
  setPassword(String password);
  setProfilePicture(File profilePicture);
}

abstract mixin class RegisterViewModelOutputs {
  Stream<bool> get outputIsUsernameValid;
  Stream<String?> get outputErrorUsername;
  Stream<bool> get outputIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;
  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;
  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;
  Stream<File> get outputIsProfilePictureValid;
  Stream<bool> get outputAreAllInputsValid;
}
