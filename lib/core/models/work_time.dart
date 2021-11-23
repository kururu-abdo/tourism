
import 'package:tourapp/core/models/day.dart';

class WorkTime {
  int id;
  String startTime;
  String endTime;
  int facilitateLocationFcilitateLocId;
  int dayDayId;
  Day day;

  WorkTime(
      {this.id,
      this.startTime,
      this.endTime,
      this.facilitateLocationFcilitateLocId,
      this.dayDayId,
      this.day});

  WorkTime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    facilitateLocationFcilitateLocId = json['facilitateLocationFcilitateLocId'];
    dayDayId = json['dayDayId'];
    day = json['day'] != null ? new Day.fromJson(json['day']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['facilitateLocationFcilitateLocId'] =
        this.facilitateLocationFcilitateLocId;
    data['dayDayId'] = this.dayDayId;
    if (this.day != null) {
      data['day'] = this.day.toJson();
    }
    return data;
  }
}
