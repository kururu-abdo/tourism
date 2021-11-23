class LocationType {
  int typeId;
  String typeArName;
  String typeEnName;
   bool isSelected;
  LocationType({this.typeId, this.typeArName, this.typeEnName ,  this.isSelected});

  LocationType.fromJson(Map<String, dynamic> json) {
    typeId = json['type_id'];
    typeArName = json['type_ar_name'];
    typeEnName = json['type_en_name'];
    isSelected =  false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_id'] = this.typeId;
    data['type_ar_name'] = this.typeArName;
    data['type_en_name'] = this.typeEnName;
    return data;
  }
}
