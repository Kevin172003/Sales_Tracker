import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:orderbook_flutter/constant/constant.dart';
import '/../../../constant/my_domain.dart';
import 'delete_product.dart';

class ProductListScreen extends StatefulWidget {
  ProductListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductListScreen> createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  final String productListApi = '${DomainName.domainName}api/products/product/';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  List<dynamic> productList = [];
  bool isLoading = true;
  int _animatedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchProductList();
  }

  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    return {'access': access};
  }

  Future<void> fetchProductList() async {
    try {
      final Map<String, String?> tokens = await getAccessTokens();
      final String? getAccessToken = tokens['access'];

      final http.Response response = await http.get(
        Uri.parse(productListApi),
        headers: {
          'Authorization': 'Bearer $getAccessToken',
          'Content-Type': 'application/json'
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['status_code'] == 200) {
          final List<dynamic> productListData = decodedResponse['data'];
          setState(() {
            productList = productListData;
            print(productList);
          });
        } else {
          print('API returned an error: ${decodedResponse['message']}');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduct(String productID) async {
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];
    final String apiDelete =
        "${DomainName.domainName}api/products/product/$productID/";
    try {
      print('{$productID}');
      final response = await http.delete(
        Uri.parse(apiDelete),
        headers: {'Authorization': 'Bearer $getAccessToken'},
      );
      if (response.statusCode == 200) {
        setState(() {
          productList.removeWhere((product) => product['id'].toString() == productID);
        });
        if (productList.isEmpty) {
          setState(() {});
        } else {
          fetchProductList();
        }
      } else {
        print('Failed to delete project. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting project: $e');
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String productID,
      void Function(String) deleteProduct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteProductConfirmationDialog(
            productID: productID, deleteProduct: deleteProduct);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        productList.isEmpty
            ? Center(child: Text('No products found'))
            : GridView.builder(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 9.0,
                childAspectRatio: 2.2,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index) {
                final productID = productList[index]['id'].toString();
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _animatedIndex = index;
                    });
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted) {
                        setState(() {
                          _animatedIndex = -1;
                        });
                      }
                      context.push('/product/subProduct/$productID');
                    });
                  },
                  onLongPress: () {
                    _showDeleteConfirmationDialog(
                        context, productID, deleteProduct);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          _animatedIndex == index ? Colors.white70 : white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        productList[index]['name'],
                        style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      ],
    );
  }
}
