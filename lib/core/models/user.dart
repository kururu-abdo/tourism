import 'package:tourapp/core/models/country.dart';

class User {
  int userId;
  String userName;
  String email;
  String password;
  String phone;
  String address;
  int countryId;
  int userTypeTypeId;
  UserType userType;
  Country country;
String pic;
  User(
      {this.userId,
      this.userName,
      this.email,
      this.password,
      this.phone,
      this.address,
      this.countryId,
      this.userTypeTypeId,
      this.userType,
      this.country ,   this.pic});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
     pic = json['pic'];
    address = json['address'];
    countryId = json['country_id'];
    userTypeTypeId = json['userTypeTypeId'];
    userType = json['user_type'] != null
        ? new UserType.fromJson(json['user_type'])
        : null;
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['country_id'] = this.countryId;
    data['userTypeTypeId'] = this.userTypeTypeId;
    data['pic'] =   this.pic??"";
    if (this.userType != null) {
      data['user_type'] = this.userType.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    return data;
  }
}

class UserType {
  int typeId;
  String typeArName;
  String typeEnName;

  UserType({this.typeId, this.typeArName, this.typeEnName});

  UserType.fromJson(Map<String, dynamic> json) {
    typeId = json['type_id'];
    typeArName = json['type_ar_name'];
    typeEnName = json['type_en_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_id'] = this.typeId;
    data['type_ar_name'] = this.typeArName;
    data['type_en_name'] = this.typeEnName;
    return data;
  }
}
