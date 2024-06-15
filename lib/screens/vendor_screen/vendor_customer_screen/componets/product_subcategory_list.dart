import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:orderbook_flutter/componets/buttons.dart';
import 'package:orderbook_flutter/constant/constant.dart';

import '../../../../constant/my_domain.dart';
import '../api_calling/addToCart_api.dart';
import '../api_calling/orderPlace_api.dart';

class ProductSubcategory extends StatefulWidget {
  final String productID;
  final String customerID;
  const ProductSubcategory(
      {super.key, required this.productID, required this.customerID});

  @override
  State<ProductSubcategory> createState() => _ProductSubcategoryState();
}

class _ProductSubcategoryState extends State<ProductSubcategory> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  List<dynamic> productSubcategory = [];
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    fetchProductSubcategoryList();
  }

  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    return {'access': access};
  }

  Future<void> fetchProductSubcategoryList() async {
    final String productSubcategoryListApi =
        '${DomainName.domainName}api/products/product/${widget.productID}/';

    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];

    final http.Response response = await http.get(
      Uri.parse(productSubcategoryListApi),
      headers: {'Authorization': 'Bearer $getAccessToken'},
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['status_code'] == 200) {
        setState(() {
          final subproducts = decodedResponse['data']['subproducts'];
          productSubcategory = subproducts.map((subproduct) {
            return {
              ...subproduct,
              'quantity': 0,
              'originalPrice': subproduct['price'],
            };
          }).toList();
        });
      } else {
        log('API returned an error: ${decodedResponse['message']}');
      }
    } else {
      log('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  void getTotalPrice() {
    for (var subproduct in productSubcategory) {
      totalPrice += (subproduct['quantity'] * subproduct['price']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: blue,
        title: Text(
          'SubProducts',
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: ClipOval(
              child: IconButton(
                icon: Icon(
                  Icons.person,
                  color: blue,
                ),
                onPressed: () {
                  GoRouter.of(context).push('/profile');
                },
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productSubcategory.length,
                itemBuilder: (BuildContext context, int index) {
                  final subproduct = productSubcategory[index];
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: ListTile(
                      title: Text(subproduct['name']),
                      subtitle: Text('Price: ${subproduct['price']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (subproduct['quantity'] > 0) {
                                  subproduct['quantity']--;
                                }
                              });
                            },
                          ),
                          Container(
                            width: 20,
                            decoration: const BoxDecoration(
                              border: null,
                            ),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              controller: TextEditingController(
                                  text: subproduct['quantity'].toString()),
                              onChanged: (value) {
                                setState(() {
                                  subproduct['quantity'] =
                                      int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                subproduct['quantity']++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        addToCart(
                            context, productSubcategory, widget.customerID);
                      },
                      buttonstyle: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(blue),
                      ),
                      buttonText: 'Add To Cart',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: CustomElevatedButton(
                        onPressed: () {
                          orderPlace(
                              context, productSubcategory, widget.customerID);
                          getTotalPrice();
                          print('Total Price: $totalPrice');
                        },
                        buttonstyle: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(blue),
                        ),
                        buttonText: 'Place Order',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
