class User {
  String name;

  User({this.name});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      name: parsedJson["country"] as String,
    );
  }
}
