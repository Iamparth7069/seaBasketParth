import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:seabasket/src/base/utils/constants/image_constant.dart';

class ImageUtils extends StatelessWidget {
  final String? base64String;
  final BoxFit fit;
  final bool fillHeight;

  const ImageUtils({
    Key? key,
    required this.base64String,
    this.fit = BoxFit.cover,
    this.fillHeight = true,
  }) : super(key: key);

  Future<Uint8List?> _decodeBase64(String? base64String) async {
    if (base64String == null || base64String.isEmpty) return null;

    try {
      final cleanBase64 = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;
      return base64Decode(cleanBase64);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _decodeBase64(base64String),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: fit,
            width: double.infinity,
            height: fillHeight ? double.infinity : null,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset(notFound, fit: fit),
          );
        } else {
          return Image.asset(notFound, fit: fit);
        }
      },
    );
  }
}
