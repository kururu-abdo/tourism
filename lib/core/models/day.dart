class Day {
  int dayId;
  String dayArName;
  String dayEnName;

  Day({this.dayId, this.dayArName, this.dayEnName});

  Day.fromJson(Map<String, dynamic> json) {
    dayId = json['day_id'];
    dayArName = json['day_ar_name'];
    dayEnName = json['day_en_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day_id'] = this.dayId;
    data['day_ar_name'] = this.dayArName;
    data['day_en_name'] = this.dayEnName;
    return data;
  }
}
