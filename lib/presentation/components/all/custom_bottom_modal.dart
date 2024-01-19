import 'package:flutter/material.dart';

Future<dynamic> showCustomModalBottom(
    {required Widget child, required BuildContext context}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
        bottom: Radius.circular(0),
      )),
      builder: (BuildContext modalContext) => child);
}
