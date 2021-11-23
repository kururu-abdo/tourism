import 'package:tourapp/core/models/user.dart';
import 'package:tourapp/services/shared_prefs.dart';

class Comment {
  int id;
  String time;
  String comment;
  int locationLocationId;
  int userUserId;
  User user;

  Comment(
      {this.id,
      this.time,
      this.comment,
      this.locationLocationId,
      this.userUserId,
      this.user});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    comment = json['comment'];
    locationLocationId = json['locationLocationId'];
    userUserId = json['userUserId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['comment'] = this.comment;
    data['locationLocationId'] = this.locationLocationId;
    data['userUserId'] = this.userUserId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
