import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:orderbook_flutter/constant/constant.dart';
import 'package:orderbook_flutter/constant/my_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  static Future<void> LogIn(BuildContext context, WidgetRef ref, String phoneNo,
      String password) async {
    String loginApi = "${DomainName.domainName}api/users/login/";
    print(loginApi);

    final FlutterSecureStorage secureStorage = FlutterSecureStorage();

    if (phoneNo.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter phone number and password',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: blue,
        textColor: white,
        fontSize: 16.0,
      );
    }

    final Map<String, dynamic> requestBody = {
      'phone_number': phoneNo,
      'password': password
    };

    // print(requestBody);
    try {
      final http.Response response = await http.post(
        Uri.parse(loginApi),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);


      if (response.statusCode == 200) {
        print(response.statusCode);
        var sharedPref = await SharedPreferences.getInstance();

        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        final String accessToken = responseData['data']['access'];
        final String refreshToken = responseData['data']['refresh'];
        final int ID = responseData['data']['id'] as int;
        final String IDString = ID.toString();
        await secureStorage.write(key: 'access', value: accessToken);
        await secureStorage.write(key: 'refresh', value: refreshToken);
        await secureStorage.write(key: 'id', value: IDString);
        final String Message = responseData['message'];
        log("Message : $Message");

        Future<Map<String, String?>> getAccessTokens() async {
          final String? refresh = await secureStorage.read(key: 'refresh');
          final String? access = await secureStorage.read(key: 'access');

          return {'refresh': refresh, 'access': access};
        }

        final Map<String, String?> tokens = await getAccessTokens();
        final String? getAccessToken = tokens['access'];
        final String? getRefreshToken = tokens['refresh'];

        print(getRefreshToken);
        print("------------------------------------------------");
        print(getAccessToken);

        if (responseData['data']['user_type'] == "vendor") {
          GoRouter.of(context).go('/product');
          sharedPref.setString('userType', 'vendor');
        } else if (responseData['data']['user_type'] == "customer") {
          context.go('/customervenorlist');
          sharedPref.setString('userType', 'customer');
        }

        sharedPref.setBool('isLoggedIn', true);
        bool isLoggedIn = sharedPref.getBool('isLoggedIn') ?? false;
        print(isLoggedIn ? 'true' : 'false');

        Fluttertoast.showToast(
          msg: Message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: blue,
          textColor: white,
          fontSize: 16.0,
        );
      } else {
        print("Please enter valid details. Status Code ${response.statusCode}");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String errorMessage = responseData['message'];
        print(errorMessage);
        print(responseData);

        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: blue,
          textColor: white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print("Error occurred during login: $e");
    }
  }
}
