import 'package:advanced_clean_architecture_with_mvvm/data/network/failure.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/network/requests.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/model/models.dart';
import 'package:dartz/dartz.dart';


// ..
// .. repository is in the domain layer 
// ... and the domain layer must not know anything from the responses
// ... the domain layer will receive the data (call back function) from the data layer
abstract class Repository {
  // .. Authentication Object not the Authentication Response (as we did in mapping)
  // .. in the data layer data_source we will receive AuthenticationResponse 
  // ... to convert it to Authentication Object
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
}
