import 'package:advanced_clean_architecture_with_mvvm/data/network/failure.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/requests.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/model/models.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/repository/repository.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  final Repository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput inputs) async {
    return await _repository.login(
      LoginRequest(inputs.email, inputs.password),
    );
  }
}

class LoginUseCaseInput {
  String email;
  String password;
  LoginUseCaseInput(this.email, this.password);
}
