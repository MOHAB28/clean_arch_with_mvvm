class SliderObject {
  final String title;
  final String subTitle;
  final String image;

  SliderObject(this.title, this.subTitle, this.image);
}

class SliderViewObject {
  final SliderObject slider;
  final int numberOfSlides;
  final int currentIndex;
  SliderViewObject({
    required this.currentIndex,
    required this.numberOfSlides,
    required this.slider,
  });
}

// login models

class Customer {
  String id;
  String name;
  int numberOfNotifications;
  Customer(this.id,this.name,this.numberOfNotifications);
}

class Contacts {
  String phone;
  String email;
  String link;
  Contacts(this.email,this.link,this.phone);
}

class Authentication {
  Customer? customer;
  Contacts? contacts;
  Authentication(this.contacts,this.customer);
}

class Service {
  int id;
  String title;
  String image;

  Service(this.id, this.title, this.image);
}

class Store {
  int id;
  String title;
  String image;

  Store(this.id, this.title, this.image);
}

class BannerAd {
  int id;
  String title;
  String image;
  String link;

  BannerAd(this.id, this.title, this.image, this.link);
}

class HomeData {
  List<Service> services;
  List<BannerAd> banners;
  List<Store> stores;

  HomeData(this.services, this.banners, this.stores);
}

class HomeObject {
  HomeData? data;

  HomeObject(this.data);
}