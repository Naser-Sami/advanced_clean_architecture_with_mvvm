import 'package:advanced_clean_architecture_with_mvvm/app/constants.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/response/responses.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST('/customers/login')
  Future<AuthenticationResponse> login(
    @Field('email') String email,
    @Field('password') String password,
  );
}
