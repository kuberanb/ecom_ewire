import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xff009688);

  static Color themedBorder(BuildContext context) {
    return Theme.of(context).colorScheme.outlineVariant;
  }

  static Color themedImagePlaceholder(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }
}
