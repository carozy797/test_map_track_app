class Post {
  String? uid;
  String? latitude;
  String? longitude;
  DateTime? created;

  Post({this.uid, this.latitude, this.longitude, this.created});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        uid: json['uid'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        created: json['created'],
      );
}
