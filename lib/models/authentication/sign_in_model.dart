class SignInModel {
  String? clientID;
  String? email;
  String? username;
  String? password;
  bool? remember;
  SignInModel(
      {this.email,
      this.password,
      this.remember = false,
      this.clientID,
      this.username});

  SignInModel.fromJson(Map<String, dynamic> json) {
    clientID = json['clientID'] ?? '-';
    email = json['email'] ?? '-';
    username = json['username'] ?? '-';
    password = json['password'] ?? '-';
    remember = json['remember'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientID'] = clientID;
    data['email'] = email;
    data['username'] = username;
    data['password'] = password;
    data['remember'] = remember;
    return data;
  }
}
