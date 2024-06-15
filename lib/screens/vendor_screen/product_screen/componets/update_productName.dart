import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '/../../../componets/buttons.dart';
import '/../../../constant/my_domain.dart';
import '../api_call/updateProductName_api.dart';

class updateProductName extends StatefulWidget {
  final Function onUpdateProductName;
  final String productId;

  const updateProductName(
      {super.key, required this.onUpdateProductName, required this.productId});

  @override
  State<updateProductName> createState() => _updateProductNameState();
}

TextEditingController updateProductController = TextEditingController();

class _updateProductNameState extends State<updateProductName> {
  bool isUpdateName = false;
  @override
  void initState() {
    super.initState();
    fetchProductList();
  }

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    return {'access': access};
  }

  Future<void> fetchProductList() async {
    final String productListApi =
        '${DomainName.domainName}api/products/product/${widget.productId}';
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];

    final http.Response response = await http.get(
      Uri.parse(productListApi),
      headers: {
        'Authorization': 'Bearer $getAccessToken',
        'Content-Type': 'application/json'
      },
    );
    print(response);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['status_code'] == 200) {
        setState(() {
          updateProductController.text = decodedResponse['data']['name'];
        });
      } else {
        print('API returned an error: ${decodedResponse['message']}');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  void updateProductName() {
    String productId = widget.productId;
    UpdateApiCall(
      productID: productId,
      context: context,
    ).updateProductName();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Update Product Name"),
      content: TextField(
        controller: updateProductController,
        decoration: InputDecoration(
          labelText: "New Product Name",
          labelStyle: TextStyle(
            color: updateProductController.text.isEmpty
                ? Colors.red
                : Colors.black54,
          ),
        ),
      ),
      actions: <Widget>[
        CustomTextButton(
          buttonText: "Cancel",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CustomElevatedButton(
          buttonText: "Update",
          onPressed: () {
            setState(() {
              if (updateProductController.text.isNotEmpty) {
                updateProductName();
              } else {
                isUpdateName = true;
                debugPrint("Enter Product Name");
              }
            });
          },
        ),
      ],
    );
  }
}
