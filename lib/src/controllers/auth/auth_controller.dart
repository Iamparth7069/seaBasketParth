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
import 'package:seabasket/src/models/request/req_verify_otp_model.dart';
import 'package:seabasket/src/models/user.dart';
import 'package:seabasket/src/providers/user_provider.dart';

class AuthController {
  Future<User?> register(BuildContext context, User user) async {
    final request = ReqRegisterModel(user: user);
    ProgressDialogUtils.showProgressDialog();
    final response = await locator<AuthApiManager>().registerApiCall(request);
    final registeredUser = response.data;
    if (registeredUser != null) {
      setString(prefkeyUserEmail, registeredUser.email);
      setString(prefkeyUserName, user.username ?? "");
      setString(prefkeyUserPhoneNumber, user.phoneNumber ?? "");
      context.read<UserProvider>().setUser(registeredUser);
      return registeredUser;
    }
    ProgressDialogUtils.dismissProgressDialog();
    return null;
  }

  Future<User?> login(
      BuildContext context, String email, String password) async {
    final request = ReqLoginModel(username: email, password: password);
    ProgressDialogUtils.showProgressDialog();
    final response = await locator<AuthApiManager>().loginApiCall(request);
    ProgressDialogUtils.dismissProgressDialog();
    if (response.access_token != null) {
      setString(prefkeyToken, response.access_token ?? "");
      setString(prefkeyUserEmail, response.email ?? "");
      setBool(prefkeyIsOtpVerified, false);
      final user = User(
        email: response.email ?? "",
      );
      context.read<UserProvider>().setUser(user);
      ProgressDialogUtils.dismissProgressDialog();
      return user;
    }

    return null;
  }

  Future<bool> verifyOtp(BuildContext context, String enteredOtp) async {
    final request = ReqVerifyOtpModel(OTP: enteredOtp);
    ProgressDialogUtils.showProgressDialog();
    final response = await locator<AuthApiManager>().verifyOtpApiCall(request);
    ProgressDialogUtils.dismissProgressDialog();
    if (response.access_token != null) {
      setString(prefkeyToken, response.access_token ?? "");
      setBool(prefkeyIsLogin, true);
      setBool(prefkeyIsOtpVerified, true);
      return true;
    }
    return false;
  }

  Future<bool> forgotPassword(BuildContext context, String email) async {
    final request = ReqForgotPasswordModel(email: email);
    ProgressDialogUtils.showProgressDialog();
    final response =
        await locator<AuthApiManager>().forgotPasswordApiCall(request);
    ProgressDialogUtils.dismissProgressDialog();
    if (response.access_token != null) {
      setString(prefkeyToken, response.access_token ?? "");
      return true;
    }
    return false;
  }

  Future<bool> resetPassword(BuildContext context, String newPassword) async {
    final request = ReqResetPasswordModel(password: newPassword);
    ProgressDialogUtils.showProgressDialog();

    final response =
        await locator<AuthApiManager>().resetPasswordApiCall(request);
    ProgressDialogUtils.dismissProgressDialog();
    if (response == null) return false;
    return response.message != null;
  }

  Future<User?> updateProfile(
    BuildContext context, {
    String? phone,
    String? address,
  }) async {
    final request = (phone != null || address != null)
        ? User(email: "", phoneNumber: phone, address: address)
        : null;

    ProgressDialogUtils.showProgressDialog();
    final response =
        await locator<AuthApiManager>().updateProfileApiCall(request);

    final updatedUser = response.data;
    ProgressDialogUtils.dismissProgressDialog();
    if (updatedUser == null) return null;
    if (phone != null) {
      setString(prefkeyUserPhoneNumber, updatedUser.phoneNumber ?? "");
    }
    if (address != null) {
      setString(prefkeyUserAddress, updatedUser.address ?? "");
    }

    context.read<UserProvider>().setUser(updatedUser);

    return updatedUser;
  }

  Future<void> logout(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    await clear();
    userProvider.clearUser();
  }
}
