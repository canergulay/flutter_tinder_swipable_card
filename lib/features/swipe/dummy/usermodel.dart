import 'package:flutter/cupertino.dart';

class UserImage {
  int? order;
  String? image;
  UserImage({this.order, this.image});
}

class User {
  final String name;
  final String designation;
  final int mutualFriends;
  final int age;
  final String imgUrl;
  final List<UserImage> images;
  final String location;
  final String bio;
  bool isLiked;
  bool isSwipedOff;

  User({
    required this.designation,
    required this.mutualFriends,
    required this.name,
    required this.age,
    required this.images,
    required this.imgUrl,
    required this.location,
    required this.bio,
    this.isLiked = false,
    this.isSwipedOff = false,
  });
}
