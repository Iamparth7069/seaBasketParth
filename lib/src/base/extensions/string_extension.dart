import 'package:flutter/material.dart';
import 'package:seabasket/src/base/utils/constants/app_constant.dart';
import 'package:seabasket/src/base/utils/enum_utils.dart';
import 'package:seabasket/src/base/utils/localization/localization.dart';
import 'package:intl/intl.dart';
import '../utils/constants/color_constant.dart';

extension StringExtension on String {
  String getInitials() => isNotEmpty
      ? trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
      : '';

  Color hexToColor() =>
      isEmpty ? secondaryColor : Color(int.parse(replaceAll('#', "0xff")));

  bool _emailValidation(String value) {
    return RegExp(validEmailRegex).hasMatch(value);
  }

  bool _phoneNumberValidation(String value) {
    return RegExp(validMobileRegex).hasMatch(value);
  }

  String? isValidPhoneNumber() {
    if (trim().isEmpty) {
      return Localization.of().msgPhoneNumberEmpty;
    } else if (!_phoneNumberValidation(trim())) {
      return Localization.of().phoneNumberInvalid;
    } else {
      return null;
    }
  }

  // Check Email Validation
  String? isValidEmail() {
    if (trim().isEmpty) {
      return Localization.of().msgEmailEmpty;
    } else if (!_emailValidation(trim())) {
      return Localization.of().msgEmailInvalid;
    } else {
      return null;
    }
  }

  // Empty Field Validation
  String? isFieldEmpty(String message) {
    if (trim().isEmpty) {
      return message;
    } else {
      return null;
    }
  }

  bool _passwordValidation(String value) {
    return RegExp(validPasswordRegex).hasMatch(value);
  }

  // Check Password Validation
  String? isValidPassword() {
    if (trim().isEmpty) {
      return Localization.of().msgPasswordEmpty;
    } else if (!_passwordValidation(trim())) {
      return Localization.of().msgPasswordError;
    } else {
      return null;
    }
  }

  // Check Valid Confirm Password
  String? isValidConfirmPassword(String newPassword) {
    if (newPassword.trim() != trim()) {
      return Localization.of().msgPasswordNotMatch;
    } else {
      return null;
    }
  }

// check card expiry date
  String? isValidExpiryDate() {
    if (trim().isEmpty) {
      return Localization.of().expiryDateEmptyMessage;
    }
    if (!contains('/')) {
      return Localization.of().invalidExpiryDateMessage;
    }
    final parts = split('/');
    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return Localization.of().invalidExpiryDateMessage;
    }
    final month = int.tryParse(parts[0]);
    if (month == null || month < 1 || month > 12) {
      return Localization.of().invalidMonthMessage;
    }
    final date = int.tryParse(parts[1]);
    if (date == null || date < 1 || date > 31) {
      return Localization.of().invalidDateMessage;
    }
    return null;
  }
}

extension ColorExtension on Color {
  String colorToHex() {
    String toHex(double value) =>
        (value * 255).toInt().toRadixString(16).padLeft(2, '0');
    return "#${toHex(r)}${toHex(g)}${toHex(b)}".toUpperCase();
  }
}

extension NumExtension on num {
  String currency() {
    try {
      final formattedPrice =
          NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(this);
      return formattedPrice;
    } catch (e) {
      return toString();
    }
  }
}
