// Make api calls here. use dio

import 'package:air_files/utils/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static final _dio = Dio();

  static String? loginToken;

  String getLoginToken() {
    return loginToken!;
  }

  Future<String> login(String userEmail, String userPassword) async {
    // get secret_token from response
    try {
      final response = await _dio.post(
        "http://13.234.59.167:3000/api/userWeb/login",
        data: {
          "userEmail": userEmail,
          "userPassword": userPassword,
        },
      );

      if (response.statusCode == 200) {
        loginToken = response.data["SECRET_TOKEN"];

        final sp = await SharedPreferences.getInstance();
        // sp.setBool("isLoggedIn", true);
        sp.setString("loginToken", loginToken!);

        showToast("Login Successful!");

        return "OK";
      } else {
        if (response.statusCode == 404) {
          return "INVALID CREDENTIALS";
        }
        return response.statusCode.toString();
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> register(
      String fullName, String userEmail, String userPassword) async {
    try {
      final response = await _dio.post(
        "http://13.234.59.167:3000/api/userWeb/register",
        data: {
          "fullName": fullName,
          "userEmail": userEmail,
          "userPassword": userPassword,
        },
      );

      if (response.statusCode == 200) {
        showToast("Registration Successful!");
        return "OK";
      } else {
        return response.statusMessage.toString();
      }
    } catch (err) {
      return err.toString();
    }
  }
}
