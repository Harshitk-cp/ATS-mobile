class LoginResponse {
  bool? success;
  String? message;
  User? user;

  LoginResponse({this.success, this.message, this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  bool? isEmployer;
  int? phone;
  String? bio;
  String? token;

  User(
      {this.id,
      this.name,
      this.email,
      this.isEmployer,
      this.phone,
      this.bio,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    isEmployer = json['isEmployer'];
    phone = json['phone'];
    bio = json['bio'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['isEmployer'] = isEmployer;
    data['phone'] = phone;
    data['bio'] = bio;
    data['token'] = token;
    return data;
  }
}
