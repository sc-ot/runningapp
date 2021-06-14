class LoginResponse {
  String? username;
  String? password;
  bool? exists;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    username = json["username"];
    password = json["password"];
    exists = json["exists"];
  }
  
}
