import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/string_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/dic_params.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/auth/auth_controller.dart';
import 'package:seabasket/src/models/request/req_login_model.dart';
import 'package:seabasket/src/widgets/primary_button.dart';

import 'package:seabasket/src/widgets/primary_text_field.dart';
import '../../base/extensions/scaffold_extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  late TapGestureRecognizer _resetPasswordRecognizer;
  late TapGestureRecognizer _tapGestureRecognizer;

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final enteredEmail = _emailController.text.trim();
    final enteredPassword = _passwordController.text.trim();
    final success = await locator<AuthController>().login(context,
        ReqLoginModel(username: enteredEmail, password: enteredPassword));
    if (success != null) {
      locator<NavigationUtils>().push(routeOtpVerify,
          arguments: {paramEmail: enteredEmail, paramIsLogin: true});
    }
  }

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        locator<NavigationUtils>().push(routeRegister);
      };
    _resetPasswordRecognizer = TapGestureRecognizer()
      ..onTap = () {
        locator<NavigationUtils>().push(routeForgotPassword);
      };
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _tapGestureRecognizer.dispose();
    _resetPasswordRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.getWidth(0.07),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Localization.of().loginTitle,
                      style: const TextStyle(
                        fontSize: fontSize28,
                        fontWeight: fontWeightSemiBold,
                        color: primaryTextColor,
                      ),
                    ),
                    Text(
                      Localization.of().loginSubtitle,
                      style: const TextStyle(
                        fontSize: fontSize16,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _getEmailTextField(),
                    const SizedBox(height: 16),
                    _getPasswordTextField(),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: Localization.of().forgotPassword,
                        style: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: fontSize14,
                        ),
                        children: [
                          const TextSpan(text: " "),
                          TextSpan(
                            recognizer: _resetPasswordRecognizer,
                            text: Localization.of().resetPassword,
                            style: const TextStyle(
                              color: primaryTextColor,
                              fontWeight: fontWeightSemiBold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _getLoginButton(),
                    const SizedBox(height: 24),
                    _getSkipButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(context.getHeight(0.01)),
          child: RichText(
            text: TextSpan(
              text: Localization.of().msgNotAccount,
              style: const TextStyle(
                color: secondaryTextColor,
                fontSize: fontSize14,
              ),
              children: [
                TextSpan(
                  text: Localization.of().joinAccount,
                  style: const TextStyle(
                    color: primaryTextColor,
                    fontWeight: fontWeightSemiBold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: _tapGestureRecognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    ).authContainerScaffold(context: context);
  }

  Widget _getEmailTextField() {
    return PrimaryTextField(
      contentPadding: const EdgeInsets.only(left: 5),
      label: Localization.of().emailLabel,
      hint: Localization.of().emailHint,
      focusNode: _emailFocus,
      type: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: _emailController,
      onFieldSubmitted: (value) {
        _emailFocus.unfocus();
        _passwordFocus.requestFocus();
      },
      validateFunction: (value) {
        return value!.isValidEmail();
      },
    );
  }

  Widget _getPasswordTextField() {
    return PrimaryTextField(
      contentPadding: const EdgeInsets.only(left: 5),
      isObscureText: true,
      label: Localization.of().passwordLabel,
      hint: Localization.of().passwordHint,
      focusNode: _passwordFocus,
      type: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      onFieldSubmitted: (value) {
        _passwordFocus.unfocus();
      },
      validateFunction: (value) {
        return value!.isValidPassword();
      },
    );
  }

  Widget _getLoginButton() {
    return PrimaryButton(
      buttonText: Localization.of().loginText,
      buttonColor: primaryButtonColor,
      backgroundColor: primaryButtonColor,
      textColor: secondaryColor,
      onButtonClick: _handleLogin,
    );
  }

  Widget _getSkipButton() {
    return TextButton(
      onPressed: () {
        locator<NavigationUtils>().pushAndRemoveUntil(routeBase);
      },
      child: Center(
        child: Text(
          Localization.of().skipText,
          style: const TextStyle(
            fontSize: fontSize14,
            color: primaryTextColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
