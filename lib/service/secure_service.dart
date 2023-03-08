import 'dart:developer';
import 'dart:io';

import 'package:anubhav/service/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utilities/base_response.dart';
import '../utilities/user_details.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();
  String? _token;
  static const String tokenKey = 'token_key';
  HTTPService http = HTTPService();

  void setToken(String token) {
    _token = token;
    log(token);
    _storage.write(key: tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  Future<bool> isSignedIn() async {
    _token = await _storage.read(key: tokenKey);
    bool signedIn = (_token ?? "").isNotEmpty;
    if (signedIn) {
      http.getUserDetails(_token!);
    }
    return signedIn;
  }

  Future<BaseResponse?> personalDetails(
      {required String phone,
      required String gender,
      required double lat,
      required double long,
      required String dob}) async {
    _token = await _storage.read(key: tokenKey);
    return await http.personalDetails(
        token: _token!,
        phone: phone,
        gender: gender,
        lat: lat,
        long: long,
        dob: dob);
  }

  Future<BaseResponse?> additionalDetails(
      {required String bldGrp,
      required String altMobile,
      required bool bp,
      required bool sugar,
      required bool heart,
      required bool pulse}) async {
    _token = await _storage.read(key: tokenKey);
    return await http.additionalDetails(
        token: _token!,
        altMobile: altMobile,
        bldGrp: bldGrp,
        bp: bp,
        sugar: sugar,
        heart: heart,
        pulse: pulse);
  }

  Future<UserDetails?> getUserDetails() async {
    _token = await _storage.read(key: tokenKey);
    return await http.getUserDetails(_token!);
  }

  Future<List<UserDetails>?> getNearByUsers() async {
    _token = await _storage.read(key: tokenKey);
    return await http.getNearbyUsers(token: _token!);
  }

  Future<void> getNearbyHospitals(double lat, double long) async {
    _token = await _storage.read(key: tokenKey);
    return await http.getNearbyHospitals(_token!, lat, long);
  }

  Future<BaseResponse?> emergencyContact(double lat, double long) async {
    _token = await _storage.read(key: tokenKey);
    return await http.emergencyContact(_token!, lat, long);
  }

  void clearStorage() {
    setToken("");
  }
}
