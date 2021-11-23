class NearLocation {
  int locationId;
  String locationEnName;
  String locationArName;
  double lat;
  double lng;
  double distance;

  NearLocation(
      {this.locationId,
      this.locationEnName,
      this.locationArName,
      this.lat,
      this.lng,
      this.distance});

  NearLocation.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    locationEnName = json['location_en_name'];
    locationArName = json['location_ar_name'];
    lat = json['lat'];
    lng = json['lng'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['location_en_name'] = this.locationEnName;
    data['location_ar_name'] = this.locationArName;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['distance'] = this.distance;
    return data;
  }
}
