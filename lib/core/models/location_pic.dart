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
