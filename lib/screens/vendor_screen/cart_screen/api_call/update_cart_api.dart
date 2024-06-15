import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:orderbook_flutter/constant/my_domain.dart';


Future<bool> updateCart(BuildContext context, List productSubcategory, customerID, cartID) async {

  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    final String? ID = await secureStorage.read(key: 'id');
    return {'access': access, 'id': ID};
  }

  String productSubcategoryListApi = '${DomainName.domainName}api/order/cart/$cartID/';
  print(productSubcategoryListApi);

  final Map<String, String?> tokens = await getAccessTokens();
  final String? getAccessToken = tokens['access'];
  final String? userID = tokens['id'];

  int iD = userID != null ? int.parse(userID) : 0;
  log("$iD");

  final List<Map<String, dynamic>> requestData = productSubcategory
      .where((subproduct) => subproduct['quantity'] > 0)
      .map((subproduct) {
    return {
      'sub_product': subproduct['id'],
      'quantity': subproduct['quantity'],
    };
  }).toList();

  final Map<String, dynamic> requestBody = {
    "customer": customerID,
    "created_by": iD,
    "cart_products": requestData,
  };

    final http.Response response = await http.patch(
      Uri.parse(productSubcategoryListApi),
      headers: {
        'Authorization': 'Bearer $getAccessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('Response status: -----------');
    print('Response body: ${response.body}');
    print('Response status: -----------');
    print(response);

    if (response.statusCode == 200) {
      // final Map<String, dynamic> responseData = jsonDecode(response.body);
      // final String message = responseData['message'] ?? 'Cart updated successfully';
      //
      // Fluttertoast.showToast(
      //   msg: message,
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: blue,
      //   textColor: white,
      //   fontSize: 16.0,
      // );
    } else {
      // final Map<String, dynamic>? responseData = jsonDecode(response.body);
      // final String errorMessage = responseData?['message'] ?? 'An error occurred';
      //
      // Fluttertoast.showToast(
      //   msg: errorMessage,
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: blue,
      //   textColor: white,
      //   fontSize: 16.0,
      // );
    }
  return true;
}
