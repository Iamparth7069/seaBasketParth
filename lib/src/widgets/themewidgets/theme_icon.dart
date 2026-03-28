import 'package:flutter/material.dart';
import 'package:seabasket/src/providers/theme_provier.dart';
import 'package:provider/provider.dart';

class ThemeIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color lightIconColor;
  final Color? darkIconColor;

  const ThemeIcon(
      {Key? key,
      required this.icon,
      this.size,
      required this.lightIconColor,
      this.darkIconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeData, _) => Icon(
        icon,
        size: size,
        color: themeData.isDarkMode ? darkIconColor : lightIconColor,
      ),
    );
  }
}
