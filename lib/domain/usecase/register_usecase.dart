import 'package:advanced_clean_architecture_with_mvvm/data/network/failure.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/requests.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/model/models.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/repository/repository.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  final Repository _repository;
  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUseCaseInput inputs) async {
    return await _repository.register(
      RegisterRequest(
          inputs.userName,
          inputs.countryMobileCode,
          inputs.mobileNumber,
          inputs.email,
          inputs.password,
          inputs.profilePicture),
    );
  }
}

class RegisterUseCaseInput {
  String userName;
  String countryMobileCode;
  String mobileNumber;
  String email;
  String password;
  String profilePicture;
  RegisterUseCaseInput(this.userName, this.countryMobileCode, this.mobileNumber,
      this.email, this.password, this.profilePicture);
}
