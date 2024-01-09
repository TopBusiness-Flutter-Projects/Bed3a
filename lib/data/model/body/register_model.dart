class RegisterModel {
  String? email;
  String? password;
  String? fName;
  String? lName;
  String? phone;
  String? socialId;
  String? loginMedium;
  int? cityId;
  RegisterModel(
      {this.email,
      this.password,
      this.fName,
      this.cityId,
      this.lName,
      this.socialId,
      this.loginMedium});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    fName = json['f_name'];
    lName = json['l_name'];
    cityId = json['city_id'];
    phone = json['phone'];
    socialId = json['social_id'];
    loginMedium = json['login_medium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['social_id'] = this.socialId;
    data['login_medium'] = this.loginMedium;
    data['city_id'] = this.cityId;
    return data;
  }
}
