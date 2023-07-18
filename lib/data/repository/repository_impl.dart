import 'package:advanced_clean_architecture_with_mvvm/data/data_source/remote_data_source.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/mapper/mapper.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/error_handler.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/failure.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/network_info.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/requests.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/model/models.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

// .. this class will implements the repository class
// ... in the domain layer
class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    // implement login

    if (await _networkInfo.isConnected) {
      //.. app is connected with internet, it's safe to call the api's

      try {
        // type of AuthenticationResponse
        final response = await _remoteDataSource.login(loginRequest);

        if (response.status == ApiInternalStatus.SUCCESS) {
          //.. success
          //.. return either right
          //.. return data

          // .. convert to Authentication Object

          return Right(response.toDomain());
        } else {
          //.. failure
          //.. return either left
          //.. return business error

          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handler(error).failure);
      }
    } else {
      //.. return either left
      //.. app is not connected with internet, show error message

      // return Left(Failure(ResponseCode.NO_INTERNET_CONNECTION, ResponseMessage.NO_INTERNET_CONNECTION));
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.forgotPassword(email);

        if (response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(response.status ?? ResponseCode.DEFAULT,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handler(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
