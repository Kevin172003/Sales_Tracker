import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/my_domain.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant/constant.dart';


const FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<Map<String, String?>> getAccessTokens() async {
  final String? refresh = await secureStorage.read(key: 'refresh');
  final String? access = await secureStorage.read(key: 'access');

  return {'refresh': refresh, 'access': access};
}

Future<void> logOut(BuildContext context, WidgetRef ref) async {
  const String logOutApi = "${DomainName.domainName}api/users/logout/";

  final Map<String, String?> tokens = await getAccessTokens();

  final String? getAccessToken = tokens['access'];
  final String? getRefreshToken = tokens['refresh'];

  if (getAccessToken != null) {
    final response = await http.post(
      Uri.parse(logOutApi),
      headers: {
        'Authorization': 'Bearer $getAccessToken',
      },
      body: {
        'refresh': getRefreshToken,
      },
    );

    if (response.statusCode == 200) {

      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool('isLoggedIn', false);
      bool isLoggedIn = sharedPref.getBool('isLoggedIn') ?? false;
      sharedPref.remove('userType');
      print(isLoggedIn ? 'true' : 'false');

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String message = responseData['message'];

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:blue,
        textColor:white,
        fontSize: 16.0,
      );
      await secureStorage.delete(key: 'access');
      await secureStorage.delete(key: 'refresh');
      GoRouter.of(context).go("/loginscreen");
    }
    else
    {
      print('Logout failed: ${response.statusCode} - ${response.body}');

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String errorMessage = responseData['message'];

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:blue,
        textColor:white,
        fontSize: 16.0,
      );
    }
  } else {
    print('Access token is null. Unable to logout.');
  }
}





