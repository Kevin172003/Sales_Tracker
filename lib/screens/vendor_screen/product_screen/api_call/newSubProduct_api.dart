import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:orderbook_flutter/constant/my_domain.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/../../../constant/constant.dart';
import '../componets/add_newsubcategory.dart';



final String createSubProductApi = "${DomainName.domainName}api/products/subproduct/";
final FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<Map<String, String?>> getAccessTokens() async {
  final String? access = await secureStorage.read(key: 'access');
  return {'access': access};
}

Future<void> addSubProduct(BuildContext context,List<Subcategory> newSubcategories, String productId,) async {
  int parsedProductId = int.tryParse(productId) ?? 0;

  List<Map<String, dynamic>> subproductData = newSubcategories.map((subcategory) {
    return {
      'name': subcategory.name,
      "product": parsedProductId,
      'price': double.parse(subcategory.price).toInt(),
    };
  }).toList();
  print(subproductData);

  final Map<String, String?> tokens = await getAccessTokens();
  final String? getAccessToken = tokens['access'];

  // final Map<String, dynamic> requestBody = {
  //   'data': subproductData,
  //
  // };

  final List<Map<String, dynamic>> requestBody = subproductData;
  final http.Response response = await http.post(
    Uri.parse(createSubProductApi),
    headers: {'Authorization': 'Bearer $getAccessToken','Content-Type': 'application/json'},
    body: jsonEncode(requestBody),
  );
  print(response.body);
  print(createSubProductApi);

  print(jsonEncode(requestBody));

  if (response.statusCode == 200) {

    // Navigator.push(context, MaterialPageRoute(builder: (context) => SubProductList(productID: productId,)));
    String productID = productId;
    GoRouter.of(context).pushReplacement('/product/subProduct/$productID');


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
      backgroundColor:blue,
      textColor:white,
      fontSize: 16.0,
    );
  }
}
