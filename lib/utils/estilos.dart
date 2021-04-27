import 'package:flutter/material.dart';

import 'app_colors.dart';

class Estilos {
    static InputDecoration getDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      border: UnderlineInputBorder(),
      labelText: label,
      labelStyle: TextStyle(color: AppColors.label),
      suffixIcon: suffixIcon,
    );
  }
}