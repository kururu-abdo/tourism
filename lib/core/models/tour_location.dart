import 'package:tourapp/core/models/tag.dart';
class TourLocation {
  int tourLocId;
  int locationLocationId;
  int tourLocationTypeTypeId;
  Location location;

  TourLocation(
      {this.tourLocId,
      this.locationLocationId,
      this.tourLocationTypeTypeId,
      this.location});

  TourLocation.fromJson(Map<String, dynamic> json) {
    tourLocId = json['tour_loc_id'];
    locationLocationId = json['locationLocationId'];
    tourLocationTypeTypeId = json['tourLocationTypeTypeId'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tour_loc_id'] = this.tourLocId;
    data['locationLocationId'] = this.locationLocationId;
    data['tourLocationTypeTypeId'] = this.tourLocationTypeTypeId;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class Location {
  int locationId;
  String locationArName;
  String locationEnName;
  String arDesc;
  String enDesc;
  double lat;
  double lng;
  int locationTypeLocationTypeId;
  int typeLocationTypeId;
  int cityCityId;
  int stateStateId;
  States state;
  City city;
  Type type;
  List<LocationPics> locationPics;
  List<LocationTags> locationTags;

  Location(
      {this.locationId,
      this.locationArName,
      this.locationEnName,
      this.arDesc,
      this.enDesc,
      this.lat,
      this.lng,
      this.locationTypeLocationTypeId,
      this.typeLocationTypeId,
      this.cityCityId,
      this.stateStateId,
      this.state,
      this.city,
      this.type,
      this.locationPics,
      this.locationTags});

  Location.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    locationArName = json['location_ar_name'];
    locationEnName = json['location_en_name'];
    arDesc = json['ar_desc'];
    enDesc = json['en_desc'];
    lat = json['lat'];
    lng = json['lng'];
    locationTypeLocationTypeId = json['locationTypeLocationTypeId'];
    typeLocationTypeId = json['typeLocationTypeId'];
    cityCityId = json['cityCityId'];
    stateStateId = json['stateStateId'];
    state = json['state'] != null ? new States.fromJson(json['state']) : null;
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
    data['locationTypeLocationTypeId'] = this.locationTypeLocationTypeId;
    data['typeLocationTypeId'] = this.typeLocationTypeId;
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

class States {
  int stateId;
  String stateArName;
  String stateEnName;

  States({this.stateId, this.stateArName, this.stateEnName});

  States.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateArName = json['state_ar_name'];
    stateEnName = json['state_en_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_ar_name'] = this.stateArName;
    data['state_en_name'] = this.stateEnName;
    return data;
  }
}

class City {
  int cityId;
  String cityArName;
  String cityEnName;
  int stateId;

  City({this.cityId, this.cityArName, this.cityEnName, this.stateId});

  City.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    cityArName = json['city_ar_name'];
    cityEnName = json['city_en_name'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['city_ar_name'] = this.cityArName;
    data['city_en_name'] = this.cityEnName;
    data['state_id'] = this.stateId;
    return data;
  }
}

class Type {
  int locationTypeId;
  String typeArName;
  String typeEnName;

  Type({this.locationTypeId, this.typeArName, this.typeEnName});

  Type.fromJson(Map<String, dynamic> json) {
    locationTypeId = json['location_type_id'];
    typeArName = json['type_ar_name'];
    typeEnName = json['type_en_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_type_id'] = this.locationTypeId;
    data['type_ar_name'] = this.typeArName;
    data['type_en_name'] = this.typeEnName;
    return data;
  }
}

class LocationPics {
  int id;
  String pic;
  int locationLocationId;

  LocationPics({this.id, this.pic, this.locationLocationId});

  LocationPics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pic = json['pic'];
    locationLocationId = json['locationLocationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pic'] = this.pic;
    data['locationLocationId'] = this.locationLocationId;
    return data;
  }
}

class LocationTags {
  int id;
  int locationLocationId;
  int tagTagId;
  Tag tag;

  LocationTags({this.id, this.locationLocationId, this.tagTagId, this.tag});

  LocationTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationLocationId = json['locationLocationId'];
    tagTagId = json['tagTagId'];
    tag = json['tag'] != null ? new Tag.fromJson(json['tag']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['locationLocationId'] = this.locationLocationId;
    data['tagTagId'] = this.tagTagId;
    if (this.tag != null) {
      data['tag'] = this.tag.toJson();
    }
    return data;
  }
}
