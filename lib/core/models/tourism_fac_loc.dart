import 'package:tourapp/core/models/facilitate_loc.dart';
import 'package:tourapp/core/models/facilitate_type.dart';

class TourismFacilitateLocation {
  int id;
  int locationId;
  int fcilitateLocId;
  int typeId;
  FacilitateLoc facilitateLocation;
  FacilitateType facilitateLocationType;

  TourismFacilitateLocation(
      {this.id,
      this.locationId,
      this.fcilitateLocId,
      this.typeId,
      this.facilitateLocation,
      this.facilitateLocationType});

  TourismFacilitateLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationId = json['location_id'];
    fcilitateLocId = json['fcilitate_loc_id'];
    typeId = json['type_id'];
    facilitateLocation = json['facilitate_location'] != null
        ? new FacilitateLoc.fromJson(json['facilitate_location'])
        : null;
    facilitateLocationType = json['facilitate_location_type'] != null
        ? new FacilitateType.fromJson(json['facilitate_location_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location_id'] = this.locationId;
    data['fcilitate_loc_id'] = this.fcilitateLocId;
    data['type_id'] = this.typeId;
    if (this.facilitateLocation != null) {
      data['facilitate_location'] = this.facilitateLocation.toJson();
    }
    if (this.facilitateLocationType != null) {
      data['facilitate_location_type'] = this.facilitateLocationType.toJson();
    }
    return data;
  }
}
