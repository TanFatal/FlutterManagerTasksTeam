import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String fullname;
  final String urlImg;

  const User(
      {required this.id,
      required this.email,
      required this.fullname,
      required this.urlImg});

  //initial
  factory User.initial() => const User(
        id: 0,
        email: '',
        fullname: '',
        urlImg: '',
      );

  //copyWith
  User copyWith({
    int? id,
    String? email,
    String? fullname,
    String? urlImg,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      urlImg: urlImg ?? this.urlImg,
    );
  }

  //fromJson
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['userId'] ?? 0,
        email: json['email'] ?? '',
        fullname: json['fullname'] ?? '',
        urlImg: json['profilePictureUrl'] ?? '',
      );

  //toJson
  Map<String, dynamic> toJson() => {
        'userId': id,
        'email': email,
        'fullname': fullname,
        'url': urlImg,
      };

  @override
  List<Object> get props => [id, email, fullname, urlImg];
}
