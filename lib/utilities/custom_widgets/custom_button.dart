import 'package:anubhav/utilities/colors.dart';
import 'package:anubhav/utilities/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget primaryButton(BuildContext context,
    {required VoidCallback onPressed,
    required String label,
    required bool processing, double height = 50}) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.primaryOrange,
          fixedSize: Size(MediaQuery.of(context).size.width, height),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      child: (!processing)
          ? Text(
              label,
              style: GoogleFonts.sourceSansPro(
                  fontSize: 22, fontWeight: FontWeight.w700),
            )
          : const CircularProgressIndicator(
              color: Colors.white,
            ).wrapCenter());
}
