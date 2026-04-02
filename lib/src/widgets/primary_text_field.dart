import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seabasket/src/base/extensions/context_extension.dart';
import '../base/utils/constants/color_constant.dart';
import '../base/utils/constants/fontsize_constant.dart';

class PrimaryTextField extends StatefulWidget {
  final String hint;
  final String label;
  final FocusNode? focusNode;
  final TextInputType? type;
  final String? trailingIcon;
  final int? maxLength;
  final bool enabled;
  final bool isObscureText;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final EdgeInsets? contentPadding;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? textInputFormatter;
  final TextEditingController controller;
  final Function(String?)? onSaved;
  final String? Function(String?)? validateFunction;
  final Function? endIconClick;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Function()? onTapped;
  final bool readOnly;
  final int maxLines;
  final bool autoFocus;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final bool hideErrorText;

  const PrimaryTextField({
    Key? key,
    required this.hint,
    required this.label,
    this.focusNode,
    this.type,
    this.trailingIcon,
    this.textStyle,
    this.isObscureText = false,
    required this.textInputAction,
    this.enabled = true,
    this.contentPadding,
    this.textAlign = TextAlign.start,
    this.onSaved,
    this.maxLength,
    this.validateFunction,
    this.endIconClick,
    this.onFieldSubmitted,
    this.textInputFormatter,
    this.onChanged,
    required this.controller,
    this.maxLines = 1,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTapped,
    this.readOnly = false,
    this.hideErrorText = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PrimaryTextFieldState();
}

class PrimaryTextFieldState extends State<PrimaryTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: widget.textStyle ??
                TextStyle(
                  color: widget.enabled ? primaryTextColor : Colors.grey,
                  fontSize: fontSize16,
                  fontWeight: fontWeightRegular,
                ),
          ),
          SizedBox(height: context.getHeight(0.004)),
        ],
        TextFormField(
          readOnly: widget.readOnly,
          textAlign: widget.textAlign,
          autofocus: widget.autoFocus,
          controller: widget.controller,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          focusNode: widget.focusNode,
          textCapitalization: TextCapitalization.sentences,
          enabled: widget.enabled,
          style: widget.textStyle ??
              TextStyle(
                color: widget.enabled ? primaryTextColor : Colors.grey,
                fontSize: fontSize16,
                fontWeight: fontWeightRegular,
              ),
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isObscureText ? _passwordIcon() : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: secondaryTextColor.withAlpha(100), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: primaryTextColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(
                color: secondaryTextColor.withAlpha(100), fontSize: fontSize14),
            counter: const Offstage(),
            contentPadding: widget.contentPadding ?? EdgeInsets.zero,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            errorStyle: widget.hideErrorText
                ? const TextStyle(height: 0, fontSize: 0)
                : const TextStyle(
                    color: Colors.red,
                    fontSize: fontSize14,
                  ),
            errorMaxLines: 3,
            labelStyle:
                const TextStyle(fontSize: fontSize14, color: Colors.grey),
          ),
          maxLines: widget.maxLines,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validateFunction,
          onSaved: widget.onSaved,
          onTap: widget.onTapped,
          inputFormatters: widget.textInputFormatter,
          keyboardType: widget.type,
          obscureText: widget.isObscureText ? _obscureText : false,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }

  _passwordIcon() => InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: SizedBox(
          height: 15,
          width: 15,
          child: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: secondaryTextColor.withAlpha(100)),
        ),
      );
}
