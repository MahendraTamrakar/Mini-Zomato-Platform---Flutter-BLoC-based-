import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profilePictureUrl;
  final String phoneNumber;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl,
    required this.phoneNumber,
  });

  //for JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePictureUrl: json['profilePictureUrl'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [id, name, email, profilePictureUrl, phoneNumber];
}
