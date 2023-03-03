import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

SnackBar awesomeBar(
    {required String title,
    required String message,
    required String contentType}) {
  late ContentType content;
  switch (contentType) {
    case 'success':
      content = ContentType.success;
      break;
    case 'failure':
      content = ContentType.failure;
      break;
    default:
      content = ContentType.warning;
  }
  return SnackBar(
    backgroundColor: Colors.transparent,
      elevation: 0,
      content: AwesomeSnackbarContent(
          title: title, message: message, contentType: content));
}
