import 'package:flutter/material.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import 'package:seabasket/src/base/utils/constants/color_constant.dart';
import 'package:seabasket/src/base/utils/constants/fontsize_constant.dart';
import 'package:seabasket/src/widgets/themewidgets/theme_text.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final Function()? onButtonClick;
  final double? width;
  final double? height;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color? backgroundColor;
  final bool isLoading;

  const PrimaryButton({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    this.width,
    this.height,
    required this.onButtonClick,
    this.textColor = Colors.white,
    this.leadingIcon,
    this.trailingIcon,
    this.backgroundColor,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onButtonClick,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: backgroundColor,
        fixedSize: Size(width ?? context.getWidth(), height ?? 50.0),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: secondaryTextColor)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    color: textColor,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
                ThemeText(
                  textAlign: TextAlign.center,
                  text: buttonText,
                  lightTextColor: textColor,
                  fontSize: fontSize15,
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, color: textColor, size: 20),
                ],
              ],
            ),
    );
  }
}
