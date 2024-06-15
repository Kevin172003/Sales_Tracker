import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../constant/constant.dart';
import '../../../../constant/my_domain.dart';
import '../../../vendor_screen/profile_screen/profilescreen.dart';
import '../componets/change_password.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';



const String changePass = "${DomainName.domainName}api/users/changepass/";

final FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<Map<String, String?>> getAccessTokens() async {
  final String? access = await secureStorage.read(key: 'access');
  return {'access': access};
}

Future<void> changePassword(BuildContext context) async {
  String oldPass = oldPassword.text;
  String newPas = newPassword.text;
  final Map<String, String?> tokens = await getAccessTokens();

  final String? getAccessToken = tokens['access'];

  final Map<String, dynamic> requestBody = {
    'old_password': oldPass,
    'new_password': newPas,
  };
  print(requestBody);

  final http.Response response = await http.post(
    Uri.parse(changePass),
    body: jsonEncode(requestBody),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $getAccessToken',
    },
  );

  if (response.statusCode == 200) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final String Message = responseData['message'];


    Fluttertoast.showToast(
      msg: Message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:blue,
      textColor:white,
      fontSize: 16.0,
    );

  }
  else
  {

    print('Change Password failed: ${response.statusCode}');
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final String errorMessage = responseData['message'];
    print(errorMessage);

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
}
