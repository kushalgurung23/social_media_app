import 'package:flutter/material.dart';

OutlineInputBorder outlineInputBorder(
    {required Color color, required double borderRadius}) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: 0.5));
}
