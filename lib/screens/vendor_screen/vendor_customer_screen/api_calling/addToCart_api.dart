import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:orderbook_flutter/constant/my_domain.dart';
import '../../../../constant/constant.dart';




Future<void> addToCart(BuildContext context,List productSubcategory,customerID) async {

  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    final String? ID = await secureStorage.read(key: 'id');
    return {'access': access, 'id':ID};
  }

  const String productSubcategoryListApi = '${DomainName.domainName}api/order/cart/';
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
      'price': subproduct['price'],
      'quantity': subproduct['quantity'],
    };
  }).toList();

  final Map<String, dynamic> requestBody = {
    "customer": customerID,
    "created_by": iD,
    "cart_products": requestData,
  };
  print(requestBody);




  final http.Response response = await http.post(
    Uri.parse(productSubcategoryListApi),
    headers: {
      'Authorization': 'Bearer $getAccessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestBody),
  );


  log("$requestBody");

  if (response.statusCode == 200) {

    // Navigator.push(context, MaterialPageRoute(builder:(context) => CustomerProductList(customerID:customerID),));
    // String customerId= customerID;
    // print(customerId);
    // // GoRouter.of(context).pushReplacement('/customer/customerProduct/$customerId');
    context.go('/cart');


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



  } else {
    print('can not send data to cart Status code: ${response.statusCode}');


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