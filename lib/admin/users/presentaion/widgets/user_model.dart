class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
    final String jobTitle;
    final String imageUrl;



  UserModel({
   required this.jobTitle, 
   required this.imageUrl, 
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      jobTitle: json['jobTitle'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'jobTitle': jobTitle,
      'imageUrl': imageUrl,
    };
  }
}
