class UserList {
  final int? userId;
  final String? name;
  final String? email;
  final String? UUid;
  UserList({this.email, this.name, this.userId, this.UUid});
  Map<String, dynamic> toMap() {
    return {'userId': userId, 'name': name, 'email': email, 'UUid': UUid};
  }

  factory UserList.fromMap(Map<String, dynamic> map) {
    return UserList(
      userId: map['userId'] as int?,
      name: map['name'] as String?,
      email: map['email'] as String?,
      UUid: map['UUid'] as String?,
    );
  }
}
