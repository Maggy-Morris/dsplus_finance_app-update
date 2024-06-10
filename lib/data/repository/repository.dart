import 'package:dsplus_finance/core/di/injector.dart';
import 'package:dsplus_finance/data/models/login/post_login_req.dart';
import 'package:dsplus_finance/data/models/login/post_login_resp.dart';
import 'package:dsplus_finance/data/models/register/post_register_req.dart';
import 'package:dsplus_finance/data/models/register/post_register_resp.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../apiClient/api_client.dart';

interface class Repository {
  ApiClient _apiClient = getIt<ApiClient>();

  Future<PostLoginResp> createLogin({required PostLoginReq user}) async {
    return await _apiClient.createLogin(user: user);
  }

  Future<PostRegisterResp> createRegister(
      {required PostRegisterReq postRegisterReq}) async {
    return await _apiClient.createRegister(user: postRegisterReq);
  }
}
