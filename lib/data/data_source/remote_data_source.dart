import 'package:advanced_clean_architecture_with_mvvm/data/network/app_api.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/requests.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/response/responses.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
}

// .. implementation (Impl)
class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;
  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
        loginRequest.email, loginRequest.password);
  }
}
