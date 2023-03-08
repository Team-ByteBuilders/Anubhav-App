import 'package:anubhav/utilities/colors.dart';
import 'package:anubhav/utilities/extensions/widget_extensions.dart';
import 'package:anubhav/utilities/user_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtherUserScreen extends StatelessWidget {
  const OtherUserScreen({Key? key, required this.user}) : super(key: key);
  final UserDetails user;

  @override
  Widget build(BuildContext context) {
    String profileImg = 'https://drive.google.com/uc?export=view&id=';
    profileImg = profileImg +
        ((user.gender == 'Male')
            ? '1kn-MtibcHUqK8o0mwReWpXan_XEEuKO0'
            : '1V1dFysLyBZZOmknRYULNQU9INVNMUt0s');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8,
        foregroundColor: CustomColors.primaryBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundColor: CustomColors.primaryBlue,
            backgroundImage: NetworkImage(
              profileImg,
            ),
          ).paddingForOnly(top: 50, bottom: 20),
          Text(
            user.name,
            style: GoogleFonts.sourceSansPro(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryOrange),
          ).paddingForOnly(bottom: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: CustomColors.primaryBlue, width: 2),
                    fixedSize:
                        Size(MediaQuery.of(context).size.width / 2.6, 50)),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Message',
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 16, color: CustomColors.primaryBlue),
                    ).paddingForOnly(right: 10),
                    const Icon(
                      Icons.send_outlined,
                      color: CustomColors.primaryBlue,
                      size: 32,
                    )
                  ],
                ).paddingWithSymmetry(vertical: 10),
              ).paddingWithSymmetry(horizontal: 15),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width / 2.6, 50),
                    side: const BorderSide(
                        color: CustomColors.primaryBlue, width: 2)),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add Friend',
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 16, color: CustomColors.primaryBlue),
                    ).paddingForOnly(right: 10),
                    const Icon(
                      Icons.person_add_outlined,
                      color: CustomColors.primaryBlue,
                      size: 32,
                    )
                  ],
                ).paddingWithSymmetry(vertical: 10),
              ).paddingWithSymmetry(horizontal: 15)
            ],
          )
        ],
      ).wrapCenter(),
    );
  }
}
