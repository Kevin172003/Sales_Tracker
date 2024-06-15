import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:orderbook_flutter/constant/my_domain.dart';
import '/../../../constant/constant.dart';
import '../componets/update_subcategory.dart';



class UpdateApiCall{

  final String  subProductID;
  final String productId;
  final BuildContext context;

  UpdateApiCall({required this.context, required  this.subProductID, required  this.productId});

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    return {'access': access};
  }


  Future<void> updateSubProductName() async{
    final String updateProductApi = '${DomainName.domainName}api/products/subproduct/${subProductID}/';
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];

    final Map<String, dynamic> updateData = {
      'name' : subProductName.text,
      'price': subProductPrice.text
    };
    print(updateData);
    print(updateProductApi);


    final response = await http.patch(
        Uri.parse(updateProductApi), headers: {'Content-Type': 'application/json','Authorization': 'Bearer $getAccessToken'},
        body: jsonEncode(updateData));

    print(response);
    print("${response.statusCode}");

    if (response.statusCode == 200) {
      String productID = productId;
      context.pushReplacement('/product/subProduct/$productID');

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


    }
    else{
      print('Failed Status code: ${response.statusCode}');

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

}