class Tag {
  int tagId;
  String tagEnName;
  String tagArName;

  Tag({this.tagId, this.tagEnName, this.tagArName});

  Tag.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    tagEnName = json['tag_en_name'];
    tagArName = json['tag_ar_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['tag_en_name'] = this.tagEnName;
    data['tag_ar_name'] = this.tagArName;
    return data;
  }
}
