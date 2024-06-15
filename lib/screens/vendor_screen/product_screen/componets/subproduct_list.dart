import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:orderbook_flutter/constant/constant.dart';
import '/../../../constant/my_domain.dart';
import 'add_newsubcategory.dart';
import 'delete_subcategory.dart';
import 'update_productName.dart';
import 'update_subcategory.dart';

class SubProductList extends StatefulWidget {
  final String productID;
  SubProductList({Key? key, required this.productID}) : super(key: key);

  @override
  State<SubProductList> createState() => SubProductListState();
}

class SubProductListState extends State<SubProductList> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  List<dynamic> productList = [];
  List<dynamic> productSubcategory = [];

  @override
  void initState() {
    super.initState();
    fetchProductSubcategoryList();
    print('${widget.productID}');
  }

  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    return {'access': access};
  }

  Future<void> fetchProductSubcategoryList() async {
    setState(() {});
    final String productSubcategoryListApi =
        '${DomainName.domainName}api/products/product/${widget.productID}/';
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];

    final http.Response response = await http.get(
      Uri.parse(productSubcategoryListApi),
      headers: {'Authorization': 'Bearer $getAccessToken'},
    );
    // print(productSubcategoryListApi);
    // print(response);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['status_code'] == 200) {
        setState(() {
          final productid = decodedResponse['data']['id'];
          final productName = decodedResponse['data']['name'];
          final subproducts = decodedResponse['data']['subproducts'];
          productList = [
            {
              'id': productid,
              'name': productName,
              'subproducts': subproducts,
            }
          ];
          productSubcategory = [
            {
              'subproducts': subproducts,
            }
          ];
          print(productList);
        });
      } else {
        print('API returned an error: ${decodedResponse['message']}');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteSubProduct(String subProductID) async {
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];
    final String apiDelete =
        "${DomainName.domainName}api/products/subproduct/$subProductID/";
    try {
      print('{$subProductID}');
      final response = await http.delete(
        Uri.parse(apiDelete),
        headers: {'Authorization': 'Bearer $getAccessToken'},
      );
      if (response.statusCode == 200) {
        fetchProductSubcategoryList();
      } else {
        print('Failed to delete project. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting project: $e');
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String subProductID,
      void Function(String) deleteSubProduct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteSubcategoryDialog(
            subProductID: subProductID, deleteSubProduct: deleteSubProduct);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: white),
        title: Text(
          "Sub Product",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        backgroundColor: blue,
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
          SizedBox(
            width: size.width * 0.02,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.02,
          ),
          GestureDetector(
            onTap: () {
              String productId =
                  productList.isNotEmpty ? productList[0]['id'].toString() : '';
              print(productId);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return updateProductName(
                    productId: productId,
                    onUpdateProductName: () {},
                  );
                },
              );
            },
            child: Container(
              width: double.infinity,
              color: white,
              // height: 50,
              height: size.height * 0.06,
              child: Center(
                child: Text(
                  productList.isNotEmpty ? productList[0]['name'] : '',
                  style: TextStyle(
                    color: blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          if (productSubcategory.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 9.0,
                    childAspectRatio: 2.2,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: productSubcategory[0]['subproducts'].length,
                  itemBuilder: (BuildContext context, int index) {
                    final subproducts = productSubcategory[0]['subproducts'];
                    return GestureDetector(
                      onTap: () {
                        String subProductID =
                            subproducts[index]['id'].toString();
                        String productId = productList.isNotEmpty
                            ? productList[0]['id'].toString()
                            : '';
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UpdateSubProduct(
                              subProductID: subProductID,
                              productId: productId,
                              onUpdateSubcategory: () {},
                            );
                          },
                        );
                      },
                      onLongPress: () {
                        String subProductID =
                            subproducts[index]['id'].toString();
                        _showDeleteConfirmationDialog(
                            context, subProductID, deleteSubProduct);
                      },
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                subproducts[index]['name'],
                                style: TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Price: ${subproducts[index]['price'].toString()}",
                                style: TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: white,
        onPressed: () {
          String productId = widget.productID;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateNewSubcategory(
                productId: productId,
                onAddSubProduct: () {},
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: blue,
        ),
      ),
    );
  }
}
