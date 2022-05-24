class User {
  User({
    this.id = '',
    this.nickName = '',
    this.joinAt = '',
  });

  final String id;
  final String nickName;
  final String joinAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? '',
        nickName: json['nickName'] ?? '',
        joinAt: json['joinAt'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickName': nickName,
        'joinAt': DateTime.now(),
      };
}
