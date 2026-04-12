import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seabasket/src/base/dependencyinjection/locator.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/extensions/scaffold_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/base/utils/constants/navigation_route_constants.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:seabasket/src/base/utils/navigation_utils.dart';
import 'package:seabasket/src/controllers/auth/auth_controller.dart';
import 'package:seabasket/src/models/request/req_forgot_password_model.dart';
import 'package:seabasket/src/models/request/req_verify_otp_model.dart';
import 'package:seabasket/src/widgets/primary_button.dart';
import 'package:seabasket/src/widgets/primary_text_field.dart';
import '../../base/utils/progress_dialog_utils.dart';

class OtpverifyScreen extends StatefulWidget {
  final String email;
  final bool isLoginScreen;
  const OtpverifyScreen(
      {Key? key, required this.email, required this.isLoginScreen})
      : super(key: key);

  @override
  State<OtpverifyScreen> createState() => _OtpverifyScreenState();
}

class _OtpverifyScreenState extends State<OtpverifyScreen> {
  final List<TextEditingController> _otpController =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  late TapGestureRecognizer _resendCodeRecognizer;

  void _verifyOtp() async {
    final enteredOtp =
        _otpController.map((controller) => controller.text).join();
    FocusScope.of(context).unfocus();
    ProgressDialogUtils.showProgressDialog();
    final success = await locator<AuthController>()
        .verifyOtp(context, ReqVerifyOtpModel(otp: enteredOtp));
    ProgressDialogUtils.dismissProgressDialog();

    if (!success || !mounted) return;
    if (widget.isLoginScreen) {
      locator<NavigationUtils>().pushAndRemoveUntil(routeBase);
    } else {
      locator<NavigationUtils>().push(routeResetPassword);
    }
  }

  @override
  void initState() {
    super.initState();
    _resendCodeRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        await locator<AuthController>().forgotPassword(
            context, ReqForgotPasswordModel(email: widget.email));
      };
  }

  @override
  void dispose() {
    _resendCodeRecognizer.dispose();
    for (var controller in _otpController) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.getHeight(0.03),
        vertical: context.getHeight(0.01),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Localization.of().otpScreenTitle,
            style: const TextStyle(
              fontSize: fontSize28,
              fontWeight: fontWeightSemiBold,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: fontSize16,
                color: secondaryTextColor,
              ),
              children: [
                TextSpan(
                  text: Localization.of().otpSubTitle1,
                ),
                TextSpan(
                  text: widget.email,
                  style: const TextStyle(
                    color: primaryTextColor,
                    fontWeight: fontWeightSemiBold,
                  ),
                ),
                TextSpan(text: Localization.of().otpSubTitle2),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _getOtpBox(),
          ]),
          const SizedBox(height: 16),
          Center(
            child: RichText(
              text: TextSpan(
                text: Localization.of().emailNotReceived,
                style: const TextStyle(
                  color: secondaryTextColor,
                  fontSize: fontSize14,
                ),
                children: [
                  const TextSpan(text: ""),
                  TextSpan(
                    recognizer: _resendCodeRecognizer,
                    text: Localization.of().resendCode,
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
          const Spacer(),
          _getContinueButton(),
          const SizedBox(height: 24),
        ],
      ),
    ).authContainerScaffold(
      context: context,
    );
  }

  Widget _getOtpBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.getWidth(0.010)),
          child: SizedBox(
            width: context.getWidth(0.18),
            height: context.getHeight(0.09),
            child: PrimaryTextField(
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              textAlign: TextAlign.center,
              textStyle: const TextStyle(
                fontSize: fontSize28,
                fontWeight: fontWeightBold,
                color: primaryTextColor,
              ),
              controller: _otpController[index],
              focusNode: _focusNodes[index],
              maxLength: 1,
              hint: '',
              label: '',
              type: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                if (value.isNotEmpty && index < 3) {
                  _focusNodes[index + 1].requestFocus();
                } else if (value.isEmpty && index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _getContinueButton() {
    return PrimaryButton(
      buttonColor: Colors.black,
      backgroundColor: primaryButtonColor,
      buttonText: Localization.of().continueText,
      textColor: secondaryColor,
      onButtonClick: _verifyOtp,
    );
  }
}
