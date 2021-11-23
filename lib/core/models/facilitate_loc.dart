class FacilitateLoc {
  int fcilitateLocId;
  String erName;
  String enName;
  String arAddress;
  String enAddress;
  String email;
  String whtsapp;
  String enShortDesc;
  String arShortDesc;

  FacilitateLoc(
      {this.fcilitateLocId,
      this.erName,
      this.enName,
      this.arAddress,
      this.enAddress,
      this.email,
      this.whtsapp,
      this.enShortDesc,
      this.arShortDesc});

  FacilitateLoc.fromJson(Map<String, dynamic> json) {
    
 print("-----JSON DATA-----------------");
    print(json);

    fcilitateLocId = json['fcilitate_loc_id'];
    erName = json['er_name'];
    enName = json['en_name'];
    arAddress = json['ar_address'];
    enAddress = json['en_address'];
    email = json['email'];
    whtsapp = json['whtsapp'];
    enShortDesc = json['en_short_desc'];
    arShortDesc = json['ar_short_desc'];

 print("-----JSON DATA-----------------");
    print(json);



  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcilitate_loc_id'] = this.fcilitateLocId;
    data['er_name'] = this.erName;
    data['en_name'] = this.enName;
    data['ar_address'] = this.arAddress;
    data['en_address'] = this.enAddress;
    data['email'] = this.email;
    data['whtsapp'] = this.whtsapp;
    data['en_short_desc'] = this.enShortDesc;
    data['ar_short_desc'] = this.arShortDesc;
    return data;
  }
}
