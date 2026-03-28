import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:seabasket/src/base/utils/constants/image_constant.dart';

class ImageUtils {
  Widget getBase64Image(String? base64String, {BoxFit fit = BoxFit.cover}) {
    if (base64String == null || base64String.isEmpty) {
      return Image.asset(notFound);
    }

    try {
      final cleanBase64 = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;

      final Uint8List bytes = base64Decode(cleanBase64);

      return Image.memory(
        bytes,
        errorBuilder: (context, error, stackTrace) => Image.asset(notFound),
      );
    } catch (e) {
      return Image.asset(notFound);
    }
  }
}
