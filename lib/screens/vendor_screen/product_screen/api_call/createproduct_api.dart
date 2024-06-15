import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:orderbook_flutter/constant/my_domain.dart';

import '/ ../../../constant/constant.dart';
import '../componets/create_product_popup.dart';

final String createProductApi = "${DomainName.domainName}api/products/product/";
final FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<Map<String, String?>> getAccessTokens() async {
  final String? access = await secureStorage.read(key: 'access');
  return {'access': access};
}

Future<void> addProduct(
  BuildContext context,
  TextEditingController productNameController,
  List<Subcategory> subcategories,
) async {
  String productName = productNameController.text;

  List<Map<String, dynamic>> subproductData = subcategories.map((subcategory) {
    return {
      'name': subcategory.name,
      'price': int.tryParse(subcategory.price) ?? 0,
    };
  }).toList();

  final Map<String, String?> tokens = await getAccessTokens();
  final String? getAccessToken = tokens['access'];

  final Map<String, dynamic> requestBody = {
    'name': productName,
    'subproducts': subproductData,
  };

  final http.Response response = await http.post(
    Uri.parse(createProductApi),
    headers: {
      'Authorization': 'Bearer $getAccessToken',
      'Content-Type': 'application/json'
    },
    body: jsonEncode(requestBody),
  );
  print(response.body);
  print(createProductApi);

  print(jsonEncode(requestBody));

  if (response.statusCode == 200) {
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ProductScreen()),
    // );
    // Navigator.pushNamed(context, '/products');
    context.pushReplacement('/product');
    Navigator.of(context).pop();
  } else {
    print("Please enter valid details. Status Code ${response.statusCode}");

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
