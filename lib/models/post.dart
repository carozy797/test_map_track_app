class Post {
  String? uid;
  String? email;
  String? surname;

  Post({this.uid, this.email, this.surname});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    uid: json['uid'],
    email: json['email'],
    surname: json['surname'],
  );
}
