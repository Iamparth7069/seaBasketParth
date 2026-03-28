import 'package:dio/dio.dart';
import 'package:seabasket/src/apis/api_route_constant.dart';
import 'package:seabasket/src/apis/api_service.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/models/request/req_forgot_password_model.dart';
import 'package:seabasket/src/models/request/req_login_model.dart';
import 'package:seabasket/src/models/request/req_register_model.dart';
import 'package:seabasket/src/models/request/req_reset_password_model.dart';
import 'package:seabasket/src/models/request/req_verify_otp_model.dart';
import 'package:seabasket/src/models/res_base_model.dart';
import 'package:seabasket/src/models/response/res_login_model.dart';
import 'package:seabasket/src/models/response/res_register_model.dart';
import 'package:seabasket/src/models/response/res_user_profile_model.dart';
import 'package:seabasket/src/models/user.dart';

class AuthApiManager {
  Future<ResRegisterModel> registerApiCall(ReqRegisterModel request) async {
    final response = await locator<ApiService>().post(
      apiRegster,
      data: request.toJson(),
    );
    return ResRegisterModel.fromJson(response!.data);
  }

  Future<ResLoginModel> loginApiCall(ReqLoginModel request) async {
    final response = await locator<ApiService>()
        .multipartPost(apiLogin, data: FormData.fromMap(request.toJson()));

    return ResLoginModel.fromJson(response!.data);
  }

  Future<ResLoginModel> verifyOtpApiCall(ReqVerifyOtpModel request) async {
    final response =
        await locator<ApiService>().post(apiVerifyOtp, data: request.toJson());
    return ResLoginModel.fromJson(response!.data);
  }

  Future<ResLoginModel> forgotPasswordApiCall(
      ReqForgotPasswordModel request) async {
    final response = await locator<ApiService>()
        .post(apiForgotPassword, data: request.toJson());
    return ResLoginModel.fromJson(response!.data);
  }

  Future<ResBaseModel?> resetPasswordPAicall(
      ReqResetPasswordModel request) async {
    final response = await locator<ApiService>()
        .patch(apiResetPassword, data: request.toJson());
    if (response == null) return null;
    return ResBaseModel.fromJson(response.data);
  }

  Future<ResUpdateProfileModel> updateProfileApiCall(User? user) async {
    final response = await locator<ApiService>().put(
      apiUpdateUser,
      data: {
        "phoneNumber": user != null ? user.phoneNumber : "",
        "address": user != null ? user.address : "",
      },
    );
    return ResUpdateProfileModel.fromJson(response!.data);
  }
}
