import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/my_domain.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../constant/constant.dart';


const String createCustomerApi = "${DomainName.domainName}api/users/customer/";
const FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<Map<String, String?>> getAccessTokens() async {
  final String? access = await secureStorage.read(key: 'access');
  return {'access': access};
}

Future<void> addCustomer(
    BuildContext context,
    TextEditingController customerName,
    TextEditingController customerNumber,
    TextEditingController customerAddress) async {
  String cusName = customerName.text;
  String cusNumber = customerNumber.text;
  String cusAddress = customerAddress.text;

  final Map<String, String?> tokens = await getAccessTokens();
  final String? getAccessToken = tokens['access'];

  final Map<String, dynamic> requestBody = {
    "first_name": cusName,
    "phone_number": cusNumber,
    "address": cusAddress,
  };

  final http.Response response = await http.post(
    Uri.parse(createCustomerApi),
    headers: {
      'Authorization': 'Bearer $getAccessToken',
      'Content-Type': 'application/json'
    },
    body: jsonEncode(requestBody),
  );
  print(response.body);

  print(jsonEncode(requestBody));

  if (response.statusCode == 200) {
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => CustomerScreen())
    // );

    GoRouter.of(context).pushReplacement('/customer');
    Navigator.of(context).pop();


    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final String massage = responseData['message'];

    Fluttertoast.showToast(
      msg: massage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: blue,
      textColor: white,
      fontSize: 16.0,
    );

  } else {
    print(" can not create customer Please enter valid details . Status Code ${response.statusCode}");

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final String errorMessage = responseData['message'];

    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: blue,
      textColor: white,
      fontSize: 16.0,
    );
  }
}
