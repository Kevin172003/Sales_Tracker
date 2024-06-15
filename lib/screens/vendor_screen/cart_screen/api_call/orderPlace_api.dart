import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:orderbook_flutter/constant/my_domain.dart';
import '/../../../constant/constant.dart';

class ThankYouDilog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Thank you for order'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            context.go('/cart');
            Navigator.of(context).pop();

          },
          child: Text('OK'),
        ),
      ],
    );
  }
}





class Apicall{

   Apicall({
    required this.context,
    required this.productSubcategory,
    required this.customerID,
    required this.idList,
    required this.cartID,
  });

  final BuildContext context;
  final List productSubcategory;
  final customerID;
  final List<int> idList;
  final cartID;

  final FlutterSecureStorage secureStorage =  FlutterSecureStorage();
    Future<Map<String, String?>> getAccessTokens() async {
      final String? access = await secureStorage.read(key: 'access');
      final String? ID = await secureStorage.read(key: 'id');
      return {'access': access, 'id':ID};
    }

    Future<void> deleteCart(String cartID ) async {
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];
    final String apiDelete =
        "${DomainName.domainName}api/order/cart/$cartID/";
        print("delete cart api:=${apiDelete}");
    try {
      final response = await http.delete(
        Uri.parse(apiDelete),
        headers: {'Authorization': 'Bearer $getAccessToken'},
      );
      print('delete cart:====${response.body}');
      if (response.statusCode == 200) {
        print("sucessfully delete");
      

      } else {
        print('Failed to delete cart. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting cart: $e');
    }
  }


  Future<void> orderPlace() async {
    final String orderPlaceApi = '${DomainName.domainName}api/order/order/';

    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];
    final String? UserID = tokens['id'];

    int iD = UserID != null ? int.parse(UserID) : 0;

    final List<Map<String, dynamic>> requestData = [];

    for (int i = 0; i < productSubcategory.length; i++) {
      final subproduct = productSubcategory[i];
      final id = idList[i];

      requestData.add({
        'sub_product': id,
        'price': subproduct['price'],
        'quantity': subproduct['quantity'],
      });
    }



    final Map<String, dynamic> requestBody = {
      "customer": customerID,
      "created_by": iD,
      "status":1,
      "cart_products": requestData,
    };
    print(requestData);
    print("========");


    final http.Response response = await http.post(
      Uri.parse(orderPlaceApi),
      headers: {
        'Authorization': 'Bearer $getAccessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );


    print("orderdata :==\n$requestBody");


    if (response.statusCode == 200) {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ThankYouDilog();
        },
      );
      deleteCart(cartID);

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

    } else {
      print('Failed to create order. Status code: ${response.statusCode}');

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

