// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  String name;
  String avatar;
  String address;
  String id;

  User({
    required this.name,
    required this.avatar,
    required this.address,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        avatar: json["avatar"],
        address: json["address"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "avatar": avatar,
        "address": address,
        "id": id,
      };

  User copyWith({
    String? name,
    String? avatar,
    String? address,
    String? id,
  }) {
    return User(
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        address: address ?? this.address,
        id: id ?? this.id);
  }
}
