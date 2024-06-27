class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String image;
  final String jobTitle;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.image = '',
    this.jobTitle = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      image: json['userImageUrl'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
    );
  }

}