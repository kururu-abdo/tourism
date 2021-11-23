class City {
  int cityId;
  String cityArName;
  String cityEnName;
  int stateStateId;

  City({this.cityId, this.cityArName, this.cityEnName, this.stateStateId});

  City.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    cityArName = json['city_ar_name'];
    cityEnName = json['city_en_name'];
    stateStateId = json['stateStateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['city_ar_name'] = this.cityArName;
    data['city_en_name'] = this.cityEnName;
    data['stateStateId'] = this.stateStateId;
    return data;
  }
}
