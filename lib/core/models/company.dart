class Company {
  Company({
     this.id,
     this.arAbout,
     this.enAbout,
     this.arName,
     this.enName,
     this.arAddress,
     this.enAddress,
     this.phone,
     this.email,
     this.whatsapp,
  });
    int id;
    String arAbout;
    String enAbout;
    String arName;
    String enName;
    String arAddress;
    String enAddress;
    String phone;
    String email;
    String whatsapp;
  
  Company.fromJson(Map<String, dynamic> json){
    id = json['id'];
    arAbout = json['ar_about'];
    enAbout = json['en_about'];
    arName = json['ar_name'];
    enName = json['en_name'];
    arAddress = json['ar_address'];
    enAddress = json['en_address'];
    phone = json['phone'];
    email = json['email'];
    whatsapp = json['whatsapp'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['ar_about'] = arAbout;
    _data['en_about'] = enAbout;
    _data['ar_name'] = arName;
    _data['en_name'] = enName;
    _data['ar_address'] = arAddress;
    _data['en_address'] = enAddress;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['whatsapp'] = whatsapp;
    return _data;
  }
}