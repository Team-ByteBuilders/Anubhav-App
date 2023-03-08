import 'package:anubhav/auth/login_screen.dart';
import 'package:anubhav/navigation/other_user_screen.dart';
import 'package:anubhav/service/hospital%20details.dart';
import 'package:anubhav/service/secure_service.dart';
import 'package:anubhav/utilities/custom_widgets/custom_button.dart';
import 'package:anubhav/utilities/extensions/widget_extensions.dart';
import 'package:anubhav/utilities/user_details.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart' as google;
import 'package:google_language_fonts/google_language_fonts.dart';
import '../utilities/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    SecureStorage storage = SecureStorage();
    UserDetails.nearbyUsers = (await storage.getNearByUsers())!;
    late double long, lat;
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position currentPosition = position;
    UserDetails.currentUser.long = currentPosition.longitude;
    UserDetails.currentUser.lat = currentPosition.latitude;
    await storage.getNearbyHospitals(
        UserDetails.currentUser.lat!, UserDetails.currentUser.long!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String profile = 'https://drive.google.com/uc?export=view&id=';
    profile = profile +
        ((UserDetails.currentUser.gender == 'Male')
            ? '1kn-MtibcHUqK8o0mwReWpXan_XEEuKO0'
            : '1V1dFysLyBZZOmknRYULNQU9INVNMUt0s');
    if (isLoading) {
      return Scaffold(
          body: const CircularProgressIndicator(
        color: Colors.red,
      ).wrapCenter());
    } else {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 8,
          // centerTitle: true,
          title: Text(
            'अनुभव',
            style: DevanagariFonts.hind(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: CustomColors.primaryBlue),
          ),
          leading: IconButton(
            onPressed: () {
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
              } else {
                scaffoldKey.currentState!.openDrawer();
              }
            },
            icon: const Icon(
              Icons.table_rows_rounded,
              color: CustomColors.primaryBlue,
              size: 32,
            ),
          ),
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'My Profile',
                  style: google.GoogleFonts.sourceSansPro(
                      fontSize: 20,
                      color: CustomColors.primaryOrange,
                      fontWeight: FontWeight.bold),
                ).paddingForOnly(top: 80),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.network(
                  profile,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ).paddingForOnly(bottom: 30),
              Text(
                'Name: ${UserDetails.currentUser.name}',
                style: google.GoogleFonts.sourceSansPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryBlue),
              ).paddingForOnly(bottom: 20),
              Text(
                'Date of Birth: ${UserDetails.currentUser.dob}',
                style: google.GoogleFonts.sourceSansPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryBlue),
              ).paddingForOnly(bottom: 20),
              Text(
                'Email: ${UserDetails.currentUser.email}',
                style: google.GoogleFonts.sourceSansPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryBlue),
              ).paddingForOnly(bottom: 20),
              Text(
                'Mobile: ${UserDetails.currentUser.phone}',
                style: google.GoogleFonts.sourceSansPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryBlue),
              ).paddingForOnly(bottom: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'See App Tutorial',
                            style: google.GoogleFonts.sourceSansPro(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: CustomColors.primaryOrange),
                          )),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, elevation: 0),
                        onPressed: () {
                          SecureStorage secure = SecureStorage();
                          // print('logout');
                          secure.setToken('');
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Logout',
                              style: google.GoogleFonts.sourceSansPro(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: CustomColors.primaryOrange),
                            ).paddingForOnly(right: 10),
                            const Icon(
                              Icons.logout_outlined,
                              size: 32,
                              color: CustomColors.primaryOrange,
                            ),
                          ],
                        ).paddingWithSymmetry(vertical: 10),
                      ).paddingWithSymmetry(vertical: 10),
                    ],
                  ),
                ),
              )
            ],
          ).paddingWithSymmetry(horizontal: 20),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Local Community',
                style: google.GoogleFonts.sourceSansPro(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryBlue),
              ).paddingForOnly(bottom: 20),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: UserDetails.nearbyUsers.length,
                    itemBuilder: (context, index) {
                      var currentUser = UserDetails.nearbyUsers[index];
                      String profileImg =
                          'https://drive.google.com/uc?export=view&id=';
                      profileImg = profileImg +
                          ((currentUser.gender == 'Male')
                              ? '1kn-MtibcHUqK8o0mwReWpXan_XEEuKO0'
                              : '1V1dFysLyBZZOmknRYULNQU9INVNMUt0s');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: Image.network(
                              profileImg,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            currentUser.name,
                            style: google.GoogleFonts.sourceSansPro(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: CustomColors.primaryOrange),
                          ),
                        ],
                      ).asButton(onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OtherUserScreen(user: currentUser)));
                      }).paddingWithSymmetry(horizontal: 20);
                    }),
              ),
              Text(
                'View Nearby Hospitals',
                style: google.GoogleFonts.sourceSansPro(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryBlue),
              ).paddingForOnly(bottom: 20),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: (HospitalDetails.nearbyHospitals.isEmpty)
                    ? Text(
                        'No Hospitals Nearby',
                        style: google.GoogleFonts.sourceSansPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.primaryOrange),
                      ).wrapCenter()
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: HospitalDetails.nearbyHospitals.length,
                        itemBuilder: (context, index) {
                          var currentHospital =
                              HospitalDetails.nearbyHospitals[index];
                          String displayImg =
                              'https://drive.google.com/uc?export=view&id=';
                          displayImg = displayImg + currentHospital.imageId;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                displayImg,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                currentHospital.name,
                                style: google.GoogleFonts.sourceSansPro(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.primaryOrange),
                              ),
                              Text(
                                currentHospital.contact,
                                style: google.GoogleFonts.sourceSansPro(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.primaryOrange),
                              ),
                            ],
                          ).paddingWithSymmetry(horizontal: 20);
                        }),
              ),
              Text(
                'Incase of Emergency',
                style: google.GoogleFonts.sourceSansPro(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryBlue),
              ).paddingForOnly(bottom: 20),
              primaryButton(context, onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text('Help is on the way...',
                              style: google.GoogleFonts.sourceSansPro(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.primaryBlue)),
                          content: Text(
                              'We are contacting your specified contacts and local Hospitals',
                              style: google.GoogleFonts.sourceSansPro(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.primaryBlue)),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Return to Home',
                                  style: TextStyle(
                                      color: CustomColors.primaryOrange),
                                ))
                          ]);
                    });
                SecureStorage storage = SecureStorage();
                await storage.emergencyContact(UserDetails.currentUser.lat!,
                    UserDetails.currentUser.long!);
              }, label: 'EMERGENCY', processing: false, height: 100)
                  .paddingForOnly(bottom: 10),
              Text(
                  'Don\'t press this unless absolutely necessary. This action is irreversible',
                  style: google.GoogleFonts.sourceSansPro(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: CustomColors.primaryBlue))
            ],
          ).paddingWithSymmetry(horizontal: 16, vertical: 16),
        ),
      );
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
