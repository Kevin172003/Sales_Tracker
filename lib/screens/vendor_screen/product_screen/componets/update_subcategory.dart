import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '/../../../componets/buttons.dart';
import '/../../../constant/my_domain.dart';
import '../api_call/updateSubProduct_api.dart';

class UpdateSubProduct extends StatefulWidget {
  final Function onUpdateSubcategory;
  final String subProductID;
  final String productId;

  const UpdateSubProduct(
      {super.key,
      required this.onUpdateSubcategory,
      required this.subProductID,
      required this.productId});

  @override
  State<UpdateSubProduct> createState() => _UpdateupdateSubProductState();
}

TextEditingController subProductName = TextEditingController();
TextEditingController subProductPrice = TextEditingController();

class _UpdateupdateSubProductState extends State<UpdateSubProduct> {
  @override
  void initState() {
    super.initState();
    fetchSubProductList();
  }

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    return {'access': access};
  }

  Future<void> fetchSubProductList() async {
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
          List<dynamic> subproducts = decodedResponse['data']['subproducts'];
          print(subproducts);

          Map<String, dynamic>? matchingSubproduct;
          for (var subproduct in subproducts) {
            // print('Subproduct ID: ${subproduct['id']}');
            // print('Widget Subproduct ID: ${widget.subProductID}');

            if (subproduct['id'].toString() == widget.subProductID) {
              matchingSubproduct = subproduct;
              break;
            }
          }

          if (matchingSubproduct != null) {
            String subproductName = matchingSubproduct['name'];
            double subproductPrice = matchingSubproduct['price'];

            // print('Subproduct Name: $subproductName');
            // print('Subproduct Price: $subproductPrice');

            subProductName.text = subproductName;
            subProductPrice.text = subproductPrice.toString();
          } else {
            print('Subproduct with ID ${widget.subProductID} not found');
          }
        });
      } else {
        print('API returned an error: ${decodedResponse['message']}');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  void updateSubProduct() {
    String subProductID = widget.subProductID;
    String productID = widget.productId;
    UpdateApiCall(
            subProductID: subProductID, productId: productID, context: context)
        .updateSubProductName();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Update SubProduct "),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: subProductName,
            decoration: InputDecoration(labelText: "New Subcategory Name"),
          ),
          SizedBox(
            height: 8,
          ),
          TextField(
            controller: subProductPrice,
            decoration: InputDecoration(labelText: "New Price"),
          ),
        ],
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
            updateSubProduct();
          },
        ),
      ],
    );
  }
}
