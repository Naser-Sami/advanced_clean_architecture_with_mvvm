// .. ONBOARDING MODEL
class SliderObject {
  final String title, subtitle, image;
  const SliderObject(this.title, this.subtitle, this.image);
}

// .. LOGIN MODELS
class Customer {
  String id;
  String name;
  int numOfNotifications;
  Customer(this.id, this.name, this.numOfNotifications);
}

class Contacts {
  String phone;
  String email;
  String link;
  Contacts(this.phone, this.email, this.link);
}

class Authentication {
  Customer? customer;
  Contacts? contacts;
  Authentication(this.customer, this.contacts);
}
