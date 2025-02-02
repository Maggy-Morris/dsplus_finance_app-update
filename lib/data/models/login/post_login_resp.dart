import 'package:dart_mappable/dart_mappable.dart';

// Will be generated by dart_mappable
part 'post_login_resp.mapper.dart';

@MappableClass()
class PostLoginResp with PostLoginRespMappable {
  final String? status;
  final String? message;
  final PostLoginRespData? data;

  PostLoginResp({this.status, this.message, this.data});
}

@MappableClass()
class PostLoginRespData with PostLoginRespDataMappable {
  int? loginRetryLimit;
  String? username;
  String? email;
  String? name;
  String? profile;
  int? role;
  String? createdAt;
  String? updatedAt;
  bool? isDeleted;
  bool? isActive;

  String? id;

  PostLoginRespData(
      {this.loginRetryLimit,
      this.username,
      this.email,
      this.name,
      this.profile,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.isDeleted,
      this.isActive,
      this.id});
}
