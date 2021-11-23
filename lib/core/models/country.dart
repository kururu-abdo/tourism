class Country {
  int countryId;
  String countryArName;
  String countryEnName;
  String countryCode;

  Country(
      {this.countryId,
      this.countryArName,
      this.countryEnName,
      this.countryCode});

  Country.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    countryArName = json['country_ar_name'];
    countryEnName = json['country_en_name'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_id'] = this.countryId;
    data['country_ar_name'] = this.countryArName;
    data['country_en_name'] = this.countryEnName;
    data['country_code'] = this.countryCode;
    return data;
  }
}
