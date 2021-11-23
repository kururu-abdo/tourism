class State {
  int stateId;
  String stateArName;
  String stateEnName;

  State({this.stateId, this.stateArName, this.stateEnName});

  State.fromJson(Map<String, dynamic> json) {
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
