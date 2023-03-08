import 'dart:convert';
import 'package:anubhav/service/hospital%20details.dart';
import 'package:anubhav/utilities/base_response.dart';
import 'package:http/http.dart' as http;
import '../utilities/user_details.dart';

class HTTPService {
  static const String _baseUrl = 'anubhavv.azurewebsites.net';
  HTTPService() : _httpClient = http.Client();

  final http.Client _httpClient;

  Map<String, String> _getHeaders(String token) =>
      {'Authorization': 'Bearer $token'};

  Future<BaseResponse?> registerUser(
      String name, String email, String password) async {
    final uri = Uri.https(_baseUrl, '/auth/register');
    final body = {"username": name, "password": password, "email": email};

    try {
      final response = await _httpClient.post(uri, body: body);
      print(response.body);
      print(response.statusCode);
      final res = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        return BaseResponse(
            msg: res['message'], responseCode: response.statusCode);
      }
    } catch (e, stackTrace) {
      print(e);
    }
  }

  Future<BaseResponse?> loginUser(String email, String password) async {
    final uri = Uri.https(_baseUrl, '/auth/login');
    final body = {"password": password, "email": email};

    try {
      final response = await _httpClient.post(uri, body: body);
      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        return BaseResponse(msg: res['token'], responseCode: 200);
      } else if (response.statusCode == 404 || response.statusCode == 401) {
        final res = jsonDecode(response.body);
        return BaseResponse(
            msg: res['message'], responseCode: response.statusCode);
      } else {
        return BaseResponse(
            msg: response.body ?? "Error", responseCode: response.statusCode);
      }
    } catch (e, stackTrace) {
      print(e);
    }
  }

  Future<BaseResponse?> personalDetails(
      {required String token,
      required String phone,
      required String gender,
      required double lat,
      required double long,
      required String dob}) async {
    final uri = Uri.https(_baseUrl, '/user/personaldetails');
    final body = {
      "dob": dob,
      "gender": gender,
      "lat": lat.toString(),
      "lon": long.toString(),
      "mobile": phone
    };

    try {
      final response =
          await _httpClient.post(uri, headers: _getHeaders(token), body: body);
      print(response.body);
      print(response.statusCode);
      final res = jsonDecode(response.body);
      return BaseResponse(
          msg: res['message'], responseCode: response.statusCode);
    } catch (e, stackTrace) {
      print(e);
    }
  }

  Future<UserDetails?> getUserDetails(String token) async {
    final uri = Uri.https(_baseUrl, '/user/getuserdetail');
    print('try');
    try {
      final response = await _httpClient.post(uri, headers: _getHeaders(token));
      final arr = response.body.substring(1, response.body.length - 1);
      print(arr);
      print(response.statusCode);
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        UserDetails.currentUser = UserDetails.fromMap(res[0]);
      }
    } catch (e, stackTrace) {
      print(e);
    }
  }

  Future<BaseResponse?> additionalDetails(
      {required String token,
      required String bldGrp,
        required String altMobile,
      required bool bp,
      required bool sugar,
      required bool heart,
      required bool pulse}) async {
    final uri = Uri.https(_baseUrl, '/user/userdetails');
    final body = {
      "altPhnNo" : altMobile,
      "bloodgroup" : bldGrp,
      "sugar" : sugar.toString(),
      "heartrate" : heart.toString(),
      "blood_pressure" : bp.toString(),
      "pulse" : pulse.toString()
    };
    try {
     final response = await _httpClient.post(uri, headers: _getHeaders(token), body: body);
     print(response.body);
     print(response.statusCode);
     final res = jsonDecode(response.body);
     return BaseResponse(msg: res['message'], responseCode: response.statusCode);
    } catch (e, stackTrace) {
      print(e);
    }
  }

  Future<List<UserDetails>?> getNearbyUsers({required String token}) async {
    final uri = Uri.https(_baseUrl, '/user/getnearbyuser');
    try {
      final response = await _httpClient.post(uri, headers: _getHeaders(token));
      print(response.body);
      print(response.statusCode);
      final res = jsonDecode(response.body);
      List<UserDetails> nearby = [];
      for(Map<String, dynamic> element in res) {
        nearby.add(UserDetails.fromMap(element));
      }
      return nearby;
    } catch (e, stackTrace) {
      print(e);
    }
  }

  Future<void> getNearbyHospitals(String token, double lat, double long) async {
    final uri = Uri.https(_baseUrl, '/hospital/gethospitals');
    final body  = {
      "lat" : lat.toString(),
      "lon" : long.toString()
    };
    try {
     final response = await _httpClient.post(uri, headers: _getHeaders(token), body: body);
     print('Hospital');
     print(response.body);
     print(response.statusCode);
     if(response.statusCode == 200) {
       final res = jsonDecode(response.body);
       for(Map<String, dynamic> map in res) {
         HospitalDetails.nearbyHospitals.add(HospitalDetails.fromMap(map));
       }
     }
    } catch (e, stackTrace) {
      print(e);
    }
  }

  Future<BaseResponse?> emergencyContact(String token, double lat, double long) async {
    final uri = Uri.https(_baseUrl, '/user/emergencybutton');
    final body  = {
      "lat" : lat.toString(),
      "lon" : long.toString()
    };
    try {
     final response = await _httpClient.post(uri, headers: _getHeaders(token), body: body);
     print(response.statusCode);
     print(response.body);
    } catch (e, stackTrace) {
      print(e);
    }
  }
}
