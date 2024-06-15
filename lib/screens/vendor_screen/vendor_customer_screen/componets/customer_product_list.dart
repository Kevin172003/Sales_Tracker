import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orderbook_flutter/constant/constant.dart';

import '../../../../constant/my_domain.dart';
import 'product_subcategory_list.dart';

class CustomerProductList extends StatefulWidget {

  final String customerID;

  const CustomerProductList({super.key, required this.customerID});

  @override
  State<CustomerProductList> createState() => _CustomerProductListState();
}

class _CustomerProductListState extends State<CustomerProductList> {


  final String productListApi = '${DomainName.domainName}api/products/product/';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  List<dynamic> productList = [];

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
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];

    final http.Response response = await http.get(
      Uri.parse(productListApi),
      headers: {'Authorization': 'Bearer $getAccessToken','Content-Type': 'application/json'},
    );
    print(response);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['status_code'] == 200) {
        setState(() {
          print(productList);
          productList = decodedResponse['data'];
        });
      } else {
        print('API returned an error: ${decodedResponse['message']}');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: blue,
        title: Text(
          'Products',
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: ClipOval(
              child: IconButton(
                icon: Icon(Icons.person,color: blue,),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(10),
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
                return GestureDetector(
                  onTap: () {
                    String productId= productList[index]['id'].toString();
                    String customerId = widget.customerID;
                    print(customerId);
                    GoRouter.of(context).push('/customer/customerProduct/$customerId/customerSubProduct/$customerId/$productId');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ProductSubcategory(productID:productID,customerID:customerID)),
                    // );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: white,
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
        ),
      ),
    );
  }
}
