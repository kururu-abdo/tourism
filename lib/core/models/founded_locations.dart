import 'package:tourapp/core/models/city.dart';
import 'package:tourapp/core/models/location_pic.dart';
import 'package:tourapp/core/models/location_tags.dart';
import 'package:tourapp/core/models/location_type.dart';
import 'package:tourapp/core/models/state.dart';
class FoundedLocations {
  int locationId;
  String locationArName;
  String locationEnName;
  String arDesc;
  String enDesc;
  double lat;
  double lng;
  int tourLocationTypeTypeId;
  int typeTypeId;
  int cityCityId;
  int stateStateId;
  State state;
  City city;
  Type type;
  List<LocationPics> locationPics;
  List<LocationTags> locationTags;

  FoundedLocations(
      {this.locationId,
      this.locationArName,
      this.locationEnName,
      this.arDesc,
      this.enDesc,
      this.lat,
      this.lng,
      this.tourLocationTypeTypeId,
      this.typeTypeId,
      this.cityCityId,
      this.stateStateId,
      this.state,
      this.city,
      this.type,
      this.locationPics,
      this.locationTags});

  FoundedLocations.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    locationArName = json['location_ar_name'];
    locationEnName = json['location_en_name'];
    arDesc = json['ar_desc'];
    enDesc = json['en_desc'];
    lat = json['lat'];
    lng = json['lng'];
    tourLocationTypeTypeId = json['tourLocationTypeTypeId'];
    typeTypeId = json['typeTypeId'];
    cityCityId = json['cityCityId'];
    stateStateId = json['stateStateId'];
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
    if (json['location_pics'] != null) {
      locationPics = new List<LocationPics>();
      json['location_pics'].forEach((v) {
        locationPics.add(new LocationPics.fromJson(v));
      });
    }
    if (json['location_tags'] != null) {
      locationTags = new List<LocationTags>();
      json['location_tags'].forEach((v) {
        locationTags.add(new LocationTags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['location_ar_name'] = this.locationArName;
    data['location_en_name'] = this.locationEnName;
    data['ar_desc'] = this.arDesc;
    data['en_desc'] = this.enDesc;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['tourLocationTypeTypeId'] = this.tourLocationTypeTypeId;
    data['typeTypeId'] = this.typeTypeId;
    data['cityCityId'] = this.cityCityId;
    data['stateStateId'] = this.stateStateId;
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    if (this.type != null) {
      data['type'] = this.type.toJson();
    }
    if (this.locationPics != null) {
      data['location_pics'] = this.locationPics.map((v) => v.toJson()).toList();
    }
    if (this.locationTags != null) {
      data['location_tags'] = this.locationTags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Type {
  int typeId;
  String typeArName;
  String typeEnName;

  Type({this.typeId, this.typeArName, this.typeEnName});

  Type.fromJson(Map<String, dynamic> json) {
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
