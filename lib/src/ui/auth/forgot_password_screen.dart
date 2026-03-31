import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/extensions/string_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/dic_params.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/auth/auth_controller.dart';
import 'package:seabasket/src/widgets/primary_button.dart';
import 'package:seabasket/src/widgets/primary_text_field.dart';

import '../../base/utils/progress_dialog_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreeState();
}

class _ForgotPasswordScreeState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  void _handleSendCode() async {
    if (!_formKey.currentState!.validate()) return;
    final enteredEmail = _emailController.text.trim();
    ProgressDialogUtils.showProgressDialog();
    final success =
        await locator<AuthController>().forgotPassword(context, enteredEmail);
    ProgressDialogUtils.dismissProgressDialog();

    if (success && mounted) {
      locator<NavigationUtils>().push(routeOtpVerify,
          arguments: {paramEmail: enteredEmail, paramisLoginScreen: false});
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.getHeight(0.03),
        vertical: context.getHeight(0.01),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Localization.of().forgotPasswordTitle,
              style: const TextStyle(
                fontSize: fontSize28,
                fontWeight: fontWeightSemiBold,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Localization.of().forgotPasswordSubTitle,
              style: const TextStyle(
                fontSize: fontSize14,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 32),
            _getEmailTextField(),
            const Spacer(),
            _getSendCodeButton(),
          ],
        ),
      ),
    ).authContainerScaffold(
        context: context,
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(top: context.getWidth(0.05)),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: primaryTextColor),
              onPressed: () {
                locator<NavigationUtils>().pop();
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
  }

  Widget _getEmailTextField() {
    return PrimaryTextField(
      contentPadding: const EdgeInsets.only(left: 5),
      label: Localization.of().emailLabel,
      hint: Localization.of().emailHint,
      focusNode: _emailFocus,
      type: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      controller: _emailController,
      onFieldSubmitted: (value) {
        _emailFocus.unfocus();
      },
      validateFunction: (value) {
        return value!.isValidEmail();
      },
    );
  }

  Widget _getSendCodeButton() {
    return PrimaryButton(
      backgroundColor: primaryButtonColor,
      buttonText: Localization.of().sendCode,
      textColor: secondaryColor,
      onButtonClick: _handleSendCode,
      buttonColor: secondaryColor,
    );
  }
}
