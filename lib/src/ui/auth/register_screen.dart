import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/string_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/auth/auth_controller.dart';
import 'package:seabasket/src/models/user.dart';
import 'package:seabasket/src/widgets/primary_button.dart';
import 'package:seabasket/src/widgets/primary_text_field.dart';
import '../../base/extensions/scaffold_extension.dart';
import '../../base/utils/progress_dialog_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TapGestureRecognizer _tapGestureRecognizer;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _userNameFocus = FocusNode();

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final enteredEmail = _emailController.text.trim();
    final enteredPassword = _passwordController.text.trim();
    final enteredUserName = _userNameController.text.trim();
    final enteredPhoneNumber = _phoneController.text.trim();

    final user = User(
        username: enteredUserName,
        email: enteredEmail,
        hashedPassword: enteredPassword,
        phoneNumber: enteredPhoneNumber);

    ProgressDialogUtils.showProgressDialog();

    final success = await locator<AuthController>().register(context, user);
    ProgressDialogUtils.dismissProgressDialog();

    if (success != null) {
      locator<NavigationUtils>().pushReplacement(routeLogin);
    }
  }

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        locator<NavigationUtils>().push(routeLogin);
      };
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _tapGestureRecognizer.dispose();
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: context.getHeight(0.06)),
              Text(
                Localization.of().registerTitle,
                style: const TextStyle(
                  fontSize: fontSize28,
                  fontWeight: fontWeightSemiBold,
                  color: primaryTextColor,
                ),
              ),
              Text(
                Localization.of().registerSubtitle,
                style: const TextStyle(
                  fontSize: fontSize16,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _getUsernameTextField(),
                      const SizedBox(height: 16),
                      _getEmailTextField(),
                      const SizedBox(height: 16),
                      _getPasswordTextField(),
                      const SizedBox(height: 16),
                      _getPhoneNumberTextField(),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          text: Localization.of().registerMessage,
                          style: const TextStyle(
                            color: secondaryTextColor,
                            fontSize: fontSize14,
                          ),
                          children: [
                            TextSpan(
                              text: Localization.of().registerTermMessage,
                              style: const TextStyle(
                                color: primaryTextColor,
                                fontWeight: fontWeightSemiBold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: " "),
                            TextSpan(
                              text: Localization.of().and,
                              style: const TextStyle(
                                color: secondaryTextColor,
                                fontSize: fontSize14,
                              ),
                            ),
                            const TextSpan(text: " "),
                            TextSpan(
                              text: Localization.of().cookieUse,
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
                      _getRegisterButton(),
                    ]),
              ),
            ]),
          )),
        ),
        Padding(
          padding: EdgeInsets.all(context.getHeight(0.01)),
          child: RichText(
            text: TextSpan(
              text: Localization.of().msgAlredyAccount,
              style: const TextStyle(
                color: secondaryTextColor,
                fontSize: fontSize14,
              ),
              children: [
                const TextSpan(text: " "),
                TextSpan(
                  text: Localization.of().loginText,
                  recognizer: _tapGestureRecognizer,
                  style: const TextStyle(
                    color: primaryTextColor,
                    fontWeight: fontWeightSemiBold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).authContainerScaffold(context: context);
  }

  Widget _getUsernameTextField() {
    return PrimaryTextField(
      contentPadding: const EdgeInsets.only(left: 5),
      label: Localization.of().userNameLabel,
      hint: Localization.of().userNameHint,
      focusNode: _userNameFocus,
      type: TextInputType.name,
      textInputAction: TextInputAction.next,
      controller: _userNameController,
      onFieldSubmitted: (value) {
        _userNameFocus.unfocus();
        _emailFocus.requestFocus();
      },
    );
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

  Widget _getPhoneNumberTextField() {
    return PrimaryTextField(
      contentPadding: const EdgeInsets.only(left: 5),
      label: Localization.of().phoneNumberText,
      hint: Localization.of().phoneNumberHint,
      controller: _phoneController,
      type: TextInputType.phone,
      textInputAction: TextInputAction.next,
      validateFunction: (value) => value?.isValidPhoneNumber(),
    );
  }

  Widget _getRegisterButton() {
    return PrimaryButton(
      buttonText: Localization.of().createAccountText,
      buttonColor: primaryButtonColor,
      backgroundColor: primaryButtonColor,
      textColor: secondaryColor,
      onButtonClick: _handleRegister,
    );
  }
}
