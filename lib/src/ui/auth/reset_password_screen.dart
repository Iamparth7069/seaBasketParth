import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/dialog_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/base/utils/progress_dialog_utils.dart';
import 'package:seabasket/src/controllers/auth/auth_controller.dart';
import 'package:seabasket/src/widgets/primary_button.dart';
import 'package:seabasket/src/widgets/primary_text_field.dart';
import '../../base/utils/progress_dialog_utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    // if (ProgressDialogUtils.isLoading) return;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (password != confirmPassword) {
      showAlertDialog(message: Localization.of().msgPasswordNotMatch);
      return;
    }
    final success =
        await locator<AuthController>().resetPassword(context, password);
    if (success && mounted) {
      _showSuccessDialog();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Localization.of().resetPasswordTitle,
                    style: const TextStyle(
                      fontSize: fontSize28,
                      fontWeight: fontWeightSemiBold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Localization.of().resetPasswordSubTitle,
                    style: const TextStyle(
                      fontSize: fontSize14,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getPasswordTextField(),
                        const SizedBox(height: 16),
                        _getConfirmPasswordTextField(),
                        const SizedBox(height: 24),
                        _getContinueButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ).authContainerScaffold(context: context, showBackButton: true);
  }

  Widget _getPasswordTextField() {
    return PrimaryTextField(
      contentPadding: const EdgeInsets.only(left: 5),
      isObscureText: true,
      label: Localization.of().passwordLabel,
      hint: "*****",
      focusNode: _passwordFocus,
      type: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      controller: _passwordController,
      onFieldSubmitted: (value) {
        _passwordFocus.unfocus();
        _confirmPasswordFocus.requestFocus();
      },
    );
  }

  Widget _getConfirmPasswordTextField() {
    return PrimaryTextField(
      contentPadding: const EdgeInsets.only(left: 5),
      isObscureText: true,
      label: Localization.of().confirmPasswordLabel,
      hint: "*****",
      focusNode: _confirmPasswordFocus,
      type: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      controller: _confirmPasswordController,
      onFieldSubmitted: (value) {
        _confirmPasswordFocus.unfocus();
      },
    );
  }

  Widget _getContinueButton() {
    return PrimaryButton(
      buttonColor: primaryButtonColor,
      backgroundColor: primaryButtonColor,
      buttonText: Localization.of().continueText,
      textColor: secondaryColor,
      onButtonClick: _handleResetPassword,
    );
  }

  void _showSuccessDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: successColor,
                  size: 80,
                ),
                const SizedBox(height: 24),
                Text(
                  Localization.of().passwordChangedText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: fontSize24,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  Localization.of().passwordChangedSubText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: fontSize14,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  buttonText: Localization.of().loginText,
                  buttonColor: primaryButtonColor,
                  backgroundColor: primaryButtonColor,
                  textColor: secondaryColor,
                  onButtonClick: () {
                    locator<NavigationUtils>().pushAndRemoveUntil(routeLogin);
                  },
                ),
              ],
            ),
          ).dialogContainer();
        });
  }
}
