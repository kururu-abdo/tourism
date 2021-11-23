import 'package:tourapp/services/shared_prefs.dart';

class FacilitateType {
  int typeId;
  String typeArName;
  String typeEnName;

  FacilitateType({this.typeId, this.typeArName, this.typeEnName});

  FacilitateType.fromJson(Map<String, dynamic> json) {
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
