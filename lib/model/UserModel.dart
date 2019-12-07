class User {
  String phone;
  String name;
  String birthdate;
  String address;
  String avatarUrl;
  String register;
  String registerDate;
  String companyName;
  int pax;

  User(
      {this.phone,
      this.name,
      this.birthdate,
      this.address,
      this.avatarUrl,
      this.register,
      this.registerDate,
      this.companyName,
      this.pax});

  User.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    name = json['name'];
    birthdate = json['birthdate'];
    address = json['address'];
    avatarUrl = json['avatarUrl'];
    register = json['Register'];
    registerDate = json['RegisterDate'];
    companyName = json['CompanyName'];
    pax = json['Pax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['birthdate'] = this.birthdate;
    data['address'] = this.address;
    data['avatarUrl'] = this.avatarUrl;
    data['Register'] = this.register;
    data['RegisterDate'] = this.registerDate;
    data['CompanyName'] = this.companyName;
    data['Pax'] = this.pax;

    return data;
  }
}
