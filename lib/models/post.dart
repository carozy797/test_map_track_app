import 'dart:convert';

class Post1 {
  String? userId;
  String? title;
  String? body;
  // DateTime? created;

  Post1({this.userId, this.title, this.body,});

  factory Post1.fromJson(Map<String, dynamic> json) => Post1(
        userId: json['userId'],
        title: json['title'],
        body: json['body'],
        // created: json['created'],
      );
}

class Post {
  int? userId;
  String? title;
  String? body;

  Post({this.userId, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        userId: json['userId'],
        title: json['title'],
        body: json['body'],
      );

  // Factory method to create a list of Post objects from a list of dynamic
  static List<Post> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((item) => Post.fromJson(item)).toList();
  }
}



class UserModel {
  final int id;
  final String username;
  final String email;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
  });

  // Factory method to create a UserModel from a map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}

void main() {
  // Example JSON response
  String jsonStr = '{"id": 1, "username": "john_doe", "email": "john.doe@example.com"}';

  // Decode the JSON string into a map
  Map<String, dynamic> jsonData = json.decode(jsonStr);

  // Create a UserModel instance from the map
  UserModel user = UserModel.fromJson(jsonData);

  // Now you can use the user object
  print("User ID: ${user.id}");
  print("Username: ${user.username}");
  print("Email: ${user.email}");
}
