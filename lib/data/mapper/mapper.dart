import 'package:advanced_clean_architecture_with_mvvm/app/constants.dart';
import 'package:advanced_clean_architecture_with_mvvm/app/extensions.dart';
import 'package:advanced_clean_architecture_with_mvvm/data/response/responses.dart';
import 'package:advanced_clean_architecture_with_mvvm/domain/model/models.dart';

/// .. MAPPER  OR MAPPING
/// ... CONVERT RESPONSE TO MODEL
/// .... toDomain means to convert response from data to domain models

extension CustomerResponseMapper on CustomerResponse? {
  // .. return Customer Object
  Customer toDomain() {
    return Customer(
        this?.id.orEmpty() ?? Constants.empty,
        this?.name.orEmpty() ?? Constants.empty,
        this?.numOfNotifications.orZero() ?? Constants.zero);
  }
}

extension ContactResponseMapper on ContactResponse? {
  // .. return Contacts Object
  Contacts toDomain() {
    return Contacts(
        this?.phone.orEmpty() ?? Constants.empty,
        this?.email.orEmpty() ?? Constants.empty,
        this?.link.orEmpty() ?? Constants.empty);
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse? {
  // .. return Authentication Object
  Authentication toDomain() {
    return Authentication(
      // .. convert from customer response to customer object
      this?.customer.toDomain(),
      // .. convert from contacts response to contacts object
      this?.contacts.toDomain(),
    );
  }
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse? {
  String toDomain() {
    return this?.support.orEmpty() ?? Constants.empty;
  }
}
