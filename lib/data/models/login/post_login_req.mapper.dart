// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'post_login_req.dart';

class PostLoginReqMapper extends ClassMapperBase<PostLoginReq> {
  PostLoginReqMapper._();

  static PostLoginReqMapper? _instance;
  static PostLoginReqMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PostLoginReqMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PostLoginReq';

  static String _$email(PostLoginReq v) => v.email;
  static const Field<PostLoginReq, String> _f$email = Field('email', _$email);
  static String _$password(PostLoginReq v) => v.password;
  static const Field<PostLoginReq, String> _f$password =
      Field('password', _$password);

  @override
  final MappableFields<PostLoginReq> fields = const {
    #email: _f$email,
    #password: _f$password,
  };

  static PostLoginReq _instantiate(DecodingData data) {
    return PostLoginReq(
        email: data.dec(_f$email), password: data.dec(_f$password));
  }

  @override
  final Function instantiate = _instantiate;

  static PostLoginReq fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PostLoginReq>(map);
  }

  static PostLoginReq fromJson(String json) {
    return ensureInitialized().decodeJson<PostLoginReq>(json);
  }
}

mixin PostLoginReqMappable {
  String toJson() {
    return PostLoginReqMapper.ensureInitialized()
        .encodeJson<PostLoginReq>(this as PostLoginReq);
  }

  Map<String, dynamic> toMap() {
    return PostLoginReqMapper.ensureInitialized()
        .encodeMap<PostLoginReq>(this as PostLoginReq);
  }

  PostLoginReqCopyWith<PostLoginReq, PostLoginReq, PostLoginReq> get copyWith =>
      _PostLoginReqCopyWithImpl(this as PostLoginReq, $identity, $identity);
  @override
  String toString() {
    return PostLoginReqMapper.ensureInitialized()
        .stringifyValue(this as PostLoginReq);
  }

  @override
  bool operator ==(Object other) {
    return PostLoginReqMapper.ensureInitialized()
        .equalsValue(this as PostLoginReq, other);
  }

  @override
  int get hashCode {
    return PostLoginReqMapper.ensureInitialized()
        .hashValue(this as PostLoginReq);
  }
}

extension PostLoginReqValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PostLoginReq, $Out> {
  PostLoginReqCopyWith<$R, PostLoginReq, $Out> get $asPostLoginReq =>
      $base.as((v, t, t2) => _PostLoginReqCopyWithImpl(v, t, t2));
}

abstract class PostLoginReqCopyWith<$R, $In extends PostLoginReq, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? email, String? password});
  PostLoginReqCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PostLoginReqCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PostLoginReq, $Out>
    implements PostLoginReqCopyWith<$R, PostLoginReq, $Out> {
  _PostLoginReqCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PostLoginReq> $mapper =
      PostLoginReqMapper.ensureInitialized();
  @override
  $R call({String? email, String? password}) => $apply(FieldCopyWithData({
        if (email != null) #email: email,
        if (password != null) #password: password
      }));
  @override
  PostLoginReq $make(CopyWithData data) => PostLoginReq(
      email: data.get(#email, or: $value.email),
      password: data.get(#password, or: $value.password));

  @override
  PostLoginReqCopyWith<$R2, PostLoginReq, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PostLoginReqCopyWithImpl($value, $cast, t);
}
