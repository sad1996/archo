import 'package:flutter/material.dart';
import 'package:get/get.dart';

showToast(String message,
        {String title,
        bool instantInit = true,
        Color backgroundColor = Colors.black,
        Color textColor = Colors.white,
        Duration duration,
        SnackPosition position = SnackPosition.BOTTOM}) =>
    Get.snackbar(title, message,
        backgroundColor: backgroundColor,
        snackPosition: position,
        duration: duration,
        instantInit: instantInit,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        colorText: textColor);
