import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:orderbook_flutter/constant/my_domain.dart';
import '../../../../constant/constant.dart';





Future<void> orderPlace(BuildContext context,List productSubcategory,customerID) async {

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    final String? ID = await secureStorage.read(key: 'id');
    return {'access': access, 'id':ID};
  }

  final String orderPlaceApi = '${DomainName.domainName}api/order/order/';


  final Map<String, String?> tokens = await getAccessTokens();
  final String? getAccessToken = tokens['access'];
  final String? UserID = tokens['id'];

  int ID = UserID != null ? int.parse(UserID) : 0;
  print(ID);

  final List<Map<String, dynamic>> requestData = productSubcategory
      .where((subproduct) => subproduct['quantity'] > 0)
      .map((subproduct) {
    return {
      'sub_product': subproduct['id'],
      'price': subproduct['price'],
      'quantity': subproduct['quantity'],
    };
  }).toList();

  final Map<String, dynamic> requestBody = {
    "customer": customerID,
    "created_by": ID,
    "status":1,
    "cart_products": requestData,
  };

  print(requestBody);



  final http.Response response = await http.post(
    Uri.parse(orderPlaceApi),
    headers: {
      'Authorization': 'Bearer $getAccessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestBody),
  );


  print(requestBody);

  if (response.statusCode == 200) {

    print(orderPlaceApi);
    GoRouter.of(context).pushReplacement('/customer');

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final String massage = responseData['message'];

    Fluttertoast.showToast(
      msg: massage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:blue,
      textColor:white,
      fontSize: 16.0,
    );

    // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>CustomerProductList(customerID: '',) ));

  } else {
    print('can not ordered place plz enter valid ddetails -  Status code: ${response.statusCode}');

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
}
