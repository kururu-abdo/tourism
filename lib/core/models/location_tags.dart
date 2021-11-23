import 'package:tourapp/core/models/tag.dart';

class LocationTags {
  int id;
  int locationLocationId;
  int tagTagId;
  Tag tag;

  LocationTags({this.id, this.locationLocationId, this.tagTagId, this.tag});

  LocationTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationLocationId = json['locationLocationId'];
    tagTagId = json['tagTagId'];
    tag = json['tag'] != null ? new Tag.fromJson(json['tag']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['locationLocationId'] = this.locationLocationId;
    data['tagTagId'] = this.tagTagId;
    if (this.tag != null) {
      data['tag'] = this.tag.toJson();
    }
    return data;
  }
}
