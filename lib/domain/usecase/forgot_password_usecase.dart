import 'package:advanced_clean_architecture_with_mvvm/data/network/failure.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/repository/repository.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class ForgotPasswordUsecase implements BaseUseCase<String, String> {
  final Repository _repository;
  ForgotPasswordUsecase(this._repository);

  @override
  Future<Either<Failure, String>> execute(String inputs) async {
    return await _repository.forgotPassword(inputs);
  }
}