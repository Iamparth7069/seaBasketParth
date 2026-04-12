import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seabasket/src/apis/apimanagers/auth_api_manager.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/utils/constants/preference_key_constant.dart';
import 'package:seabasket/src/base/utils/preference_utils.dart';
import 'package:seabasket/src/base/utils/progress_dialog_utils.dart';
import 'package:seabasket/src/models/request/req_forgot_password_model.dart';
import 'package:seabasket/src/models/request/req_login_model.dart';
import 'package:seabasket/src/models/request/req_register_model.dart';
import 'package:seabasket/src/models/request/req_reset_password_model.dart';
import 'package:seabasket/src/models/request/req_update_profile_model.dart';
import 'package:seabasket/src/models/request/req_user_model.dart';
import 'package:seabasket/src/models/request/req_verify_otp_model.dart';
import 'package:seabasket/src/models/user.dart';
import 'package:seabasket/src/providers/user_provider.dart';

class AuthController {
  Future<User?> register(BuildContext context, ReqUserModel user) async {
    final request = ReqRegisterModel(user: user);
    ProgressDialogUtils.showProgressDialog();
    final response = await locator<AuthApiManager>().registerApiCall(request);
    final registeredUser = response.data;
    if (registeredUser != null) {
      setString(prefkeyUserEmail, registeredUser.email);
      setString(prefkeyUserName, registeredUser.username ?? "");
      setString(prefkeyUserPhoneNumber, registeredUser.phoneNumber ?? "");
      context.read<UserProvider>().setUser(registeredUser);
      return registeredUser;
    }
    ProgressDialogUtils.dismissProgressDialog();
    return null;
  }

  Future<User?> login(BuildContext context, ReqLoginModel request) async {
    ProgressDialogUtils.showProgressDialog();

    return locator<AuthApiManager>().loginApiCall(request).whenComplete(() {
      ProgressDialogUtils.dismissProgressDialog();
    }).then((response) {
      final loginData = response.data;
      if (loginData?.accessToken != null) {
        setString(prefkeyToken, loginData?.accessToken ?? "");
        setString(prefkeyUserEmail, loginData?.email ?? "");
        setBool(prefkeyIsOtpVerified, false);

        final user = User(email: loginData?.email ?? "");
        context.read<UserProvider>().setUser(user);
        return user;
      }
      return null;
    });
  }

  Future<bool> verifyOtp(
      BuildContext context, ReqVerifyOtpModel request) async {
    final response = await locator<AuthApiManager>().verifyOtpApiCall(request);
    ProgressDialogUtils.dismissProgressDialog();
    if (response.data?.accessToken != null) {
      setString(prefkeyToken, response.data?.accessToken ?? "");
      setBool(prefkeyIsLogin, true);
      setBool(prefkeyIsOtpVerified, true);
      return true;
    }
    return false;
  }

  Future<bool> forgotPassword(
      BuildContext context, ReqForgotPasswordModel request) async {
    final response =
        await locator<AuthApiManager>().forgotPasswordApiCall(request);
    if (response.data?.accessToken != null) {
      setString(prefkeyToken, response.data?.accessToken ?? "");
      return true;
    }
    return false;
  }

  Future<bool> resetPassword(
      BuildContext context, ReqResetPasswordModel request) async {
    final response =
        await locator<AuthApiManager>().resetPasswordApiCall(request);
    ProgressDialogUtils.dismissProgressDialog();
    return response.message != null;
  }

  Future<User?> updateProfile(
    BuildContext context,
    ReqUpdateProfileModel request,
  ) async {
    ProgressDialogUtils.showProgressDialog();
    final response =
        await locator<AuthApiManager>().updateProfileApiCall(request);

    final updatedUser = response.data;
    ProgressDialogUtils.dismissProgressDialog();
    if (updatedUser == null) return null;
    setString(prefkeyUserPhoneNumber, updatedUser.phoneNumber ?? "");
    setString(prefkeyUserAddress, updatedUser.address ?? "");
    context.read<UserProvider>().setUser(updatedUser);

    return updatedUser;
  }

  Future<void> logout(BuildContext context) async {
    await clear();
    context.read<UserProvider>().clearUser();
  }
}
