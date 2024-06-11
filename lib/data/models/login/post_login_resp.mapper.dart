// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'post_login_resp.dart';

class PostLoginRespMapper extends ClassMapperBase<PostLoginResp> {
  PostLoginRespMapper._();

  static PostLoginRespMapper? _instance;
  static PostLoginRespMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PostLoginRespMapper._());
      PostLoginRespDataMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PostLoginResp';

  static String? _$status(PostLoginResp v) => v.status;
  static const Field<PostLoginResp, String> _f$status =
      Field('status', _$status, opt: true);
  static String? _$message(PostLoginResp v) => v.message;
  static const Field<PostLoginResp, String> _f$message =
      Field('message', _$message, opt: true);
  static PostLoginRespData? _$data(PostLoginResp v) => v.data;
  static const Field<PostLoginResp, PostLoginRespData> _f$data =
      Field('data', _$data, opt: true);

  @override
  final MappableFields<PostLoginResp> fields = const {
    #status: _f$status,
    #message: _f$message,
    #data: _f$data,
  };

  static PostLoginResp _instantiate(DecodingData data) {
    return PostLoginResp(
        status: data.dec(_f$status),
        message: data.dec(_f$message),
        data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static PostLoginResp fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PostLoginResp>(map);
  }

  static PostLoginResp fromJson(String json) {
    return ensureInitialized().decodeJson<PostLoginResp>(json);
  }
}

mixin PostLoginRespMappable {
  String toJson() {
    return PostLoginRespMapper.ensureInitialized()
        .encodeJson<PostLoginResp>(this as PostLoginResp);
  }

  Map<String, dynamic> toMap() {
    return PostLoginRespMapper.ensureInitialized()
        .encodeMap<PostLoginResp>(this as PostLoginResp);
  }

  PostLoginRespCopyWith<PostLoginResp, PostLoginResp, PostLoginResp>
      get copyWith => _PostLoginRespCopyWithImpl(
          this as PostLoginResp, $identity, $identity);
  @override
  String toString() {
    return PostLoginRespMapper.ensureInitialized()
        .stringifyValue(this as PostLoginResp);
  }

  @override
  bool operator ==(Object other) {
    return PostLoginRespMapper.ensureInitialized()
        .equalsValue(this as PostLoginResp, other);
  }

  @override
  int get hashCode {
    return PostLoginRespMapper.ensureInitialized()
        .hashValue(this as PostLoginResp);
  }
}

extension PostLoginRespValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PostLoginResp, $Out> {
  PostLoginRespCopyWith<$R, PostLoginResp, $Out> get $asPostLoginResp =>
      $base.as((v, t, t2) => _PostLoginRespCopyWithImpl(v, t, t2));
}

abstract class PostLoginRespCopyWith<$R, $In extends PostLoginResp, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PostLoginRespDataCopyWith<$R, PostLoginRespData, PostLoginRespData>? get data;
  $R call({String? status, String? message, PostLoginRespData? data});
  PostLoginRespCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PostLoginRespCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PostLoginResp, $Out>
    implements PostLoginRespCopyWith<$R, PostLoginResp, $Out> {
  _PostLoginRespCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PostLoginResp> $mapper =
      PostLoginRespMapper.ensureInitialized();
  @override
  PostLoginRespDataCopyWith<$R, PostLoginRespData, PostLoginRespData>?
      get data => $value.data?.copyWith.$chain((v) => call(data: v));
  @override
  $R call(
          {Object? status = $none,
          Object? message = $none,
          Object? data = $none}) =>
      $apply(FieldCopyWithData({
        if (status != $none) #status: status,
        if (message != $none) #message: message,
        if (data != $none) #data: data
      }));
  @override
  PostLoginResp $make(CopyWithData data) => PostLoginResp(
      status: data.get(#status, or: $value.status),
      message: data.get(#message, or: $value.message),
      data: data.get(#data, or: $value.data));

  @override
  PostLoginRespCopyWith<$R2, PostLoginResp, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PostLoginRespCopyWithImpl($value, $cast, t);
}

class PostLoginRespDataMapper extends ClassMapperBase<PostLoginRespData> {
  PostLoginRespDataMapper._();

  static PostLoginRespDataMapper? _instance;
  static PostLoginRespDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PostLoginRespDataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PostLoginRespData';

  static int? _$loginRetryLimit(PostLoginRespData v) => v.loginRetryLimit;
  static const Field<PostLoginRespData, int> _f$loginRetryLimit =
      Field('loginRetryLimit', _$loginRetryLimit, opt: true);
  static String? _$username(PostLoginRespData v) => v.username;
  static const Field<PostLoginRespData, String> _f$username =
      Field('username', _$username, opt: true);
  static String? _$email(PostLoginRespData v) => v.email;
  static const Field<PostLoginRespData, String> _f$email =
      Field('email', _$email, opt: true);
  static String? _$name(PostLoginRespData v) => v.name;
  static const Field<PostLoginRespData, String> _f$name =
      Field('name', _$name, opt: true);
  static String? _$profile(PostLoginRespData v) => v.profile;
  static const Field<PostLoginRespData, String> _f$profile =
      Field('profile', _$profile, opt: true);
  static String? _$role(PostLoginRespData v) => v.role;
  static const Field<PostLoginRespData, int> _f$role =
      Field('role', _$role, opt: true);
  static String? _$createdAt(PostLoginRespData v) => v.createdAt;
  static const Field<PostLoginRespData, String> _f$createdAt =
      Field('createdAt', _$createdAt, opt: true);
  static String? _$updatedAt(PostLoginRespData v) => v.updatedAt;
  static const Field<PostLoginRespData, String> _f$updatedAt =
      Field('updatedAt', _$updatedAt, opt: true);
  static bool? _$isDeleted(PostLoginRespData v) => v.isDeleted;
  static const Field<PostLoginRespData, bool> _f$isDeleted =
      Field('isDeleted', _$isDeleted, opt: true);
  static bool? _$isActive(PostLoginRespData v) => v.isActive;
  static const Field<PostLoginRespData, bool> _f$isActive =
      Field('isActive', _$isActive, opt: true);
  static String? _$id(PostLoginRespData v) => v.id;
  static const Field<PostLoginRespData, String> _f$id =
      Field('id', _$id, opt: true);

  @override
  final MappableFields<PostLoginRespData> fields = const {
    #loginRetryLimit: _f$loginRetryLimit,
    #username: _f$username,
    #email: _f$email,
    #name: _f$name,
    #profile: _f$profile,
    #role: _f$role,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #isDeleted: _f$isDeleted,
    #isActive: _f$isActive,
    #id: _f$id,
  };

  static PostLoginRespData _instantiate(DecodingData data) {
    return PostLoginRespData(
        loginRetryLimit: data.dec(_f$loginRetryLimit),
        username: data.dec(_f$username),
        email: data.dec(_f$email),
        name: data.dec(_f$name),
        profile: data.dec(_f$profile),
        role: data.dec(_f$role),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        isDeleted: data.dec(_f$isDeleted),
        isActive: data.dec(_f$isActive),
        id: data.dec(_f$id));
  }

  @override
  final Function instantiate = _instantiate;

  static PostLoginRespData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PostLoginRespData>(map);
  }

  static PostLoginRespData fromJson(String json) {
    return ensureInitialized().decodeJson<PostLoginRespData>(json);
  }
}

mixin PostLoginRespDataMappable {
  String toJson() {
    return PostLoginRespDataMapper.ensureInitialized()
        .encodeJson<PostLoginRespData>(this as PostLoginRespData);
  }

  Map<String, dynamic> toMap() {
    return PostLoginRespDataMapper.ensureInitialized()
        .encodeMap<PostLoginRespData>(this as PostLoginRespData);
  }

  PostLoginRespDataCopyWith<PostLoginRespData, PostLoginRespData,
          PostLoginRespData>
      get copyWith => _PostLoginRespDataCopyWithImpl(
          this as PostLoginRespData, $identity, $identity);
  @override
  String toString() {
    return PostLoginRespDataMapper.ensureInitialized()
        .stringifyValue(this as PostLoginRespData);
  }

  @override
  bool operator ==(Object other) {
    return PostLoginRespDataMapper.ensureInitialized()
        .equalsValue(this as PostLoginRespData, other);
  }

  @override
  int get hashCode {
    return PostLoginRespDataMapper.ensureInitialized()
        .hashValue(this as PostLoginRespData);
  }
}

extension PostLoginRespDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PostLoginRespData, $Out> {
  PostLoginRespDataCopyWith<$R, PostLoginRespData, $Out>
      get $asPostLoginRespData =>
          $base.as((v, t, t2) => _PostLoginRespDataCopyWithImpl(v, t, t2));
}

abstract class PostLoginRespDataCopyWith<$R, $In extends PostLoginRespData,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {int? loginRetryLimit,
      String? username,
      String? email,
      String? name,
      String? profile,
      int? role,
      String? createdAt,
      String? updatedAt,
      bool? isDeleted,
      bool? isActive,
      String? id});
  PostLoginRespDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PostLoginRespDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PostLoginRespData, $Out>
    implements PostLoginRespDataCopyWith<$R, PostLoginRespData, $Out> {
  _PostLoginRespDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PostLoginRespData> $mapper =
      PostLoginRespDataMapper.ensureInitialized();
  @override
  $R call(
          {Object? loginRetryLimit = $none,
          Object? username = $none,
          Object? email = $none,
          Object? name = $none,
          Object? profile = $none,
          Object? role = $none,
          Object? createdAt = $none,
          Object? updatedAt = $none,
          Object? isDeleted = $none,
          Object? isActive = $none,
          Object? id = $none}) =>
      $apply(FieldCopyWithData({
        if (loginRetryLimit != $none) #loginRetryLimit: loginRetryLimit,
        if (username != $none) #username: username,
        if (email != $none) #email: email,
        if (name != $none) #name: name,
        if (profile != $none) #profile: profile,
        if (role != $none) #role: role,
        if (createdAt != $none) #createdAt: createdAt,
        if (updatedAt != $none) #updatedAt: updatedAt,
        if (isDeleted != $none) #isDeleted: isDeleted,
        if (isActive != $none) #isActive: isActive,
        if (id != $none) #id: id
      }));
  @override
  PostLoginRespData $make(CopyWithData data) => PostLoginRespData(
      loginRetryLimit: data.get(#loginRetryLimit, or: $value.loginRetryLimit),
      username: data.get(#username, or: $value.username),
      email: data.get(#email, or: $value.email),
      name: data.get(#name, or: $value.name),
      profile: data.get(#profile, or: $value.profile),
      role: data.get(#role, or: $value.role),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      isDeleted: data.get(#isDeleted, or: $value.isDeleted),
      isActive: data.get(#isActive, or: $value.isActive),
      id: data.get(#id, or: $value.id));

  @override
  PostLoginRespDataCopyWith<$R2, PostLoginRespData, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PostLoginRespDataCopyWithImpl($value, $cast, t);
}
