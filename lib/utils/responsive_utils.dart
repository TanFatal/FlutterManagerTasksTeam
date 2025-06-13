import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getProductImageSize(BuildContext context) {
    if (isMobile(context)) return 100;
    if (isTablet(context)) return 150;
    return 200;
  }

  static EdgeInsets getDefaultPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(8);
    if (isTablet(context)) return const EdgeInsets.all(12);
    return const EdgeInsets.all(32);
  }

  static double getDefaultSpacing(BuildContext context) {
    if (isMobile(context)) return 8;
    if (isTablet(context)) return 12;
    return 16;
  }

  static double getFontSize(BuildContext context, {required double fontSize}) {
    if (isMobile(context)) return fontSize;
    if (isTablet(context)) return fontSize * 1.2;
    return fontSize * 1.4;
  }

  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 600;
    return 800;
  }
}
