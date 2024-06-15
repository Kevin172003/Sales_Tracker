import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:orderbook_flutter/componets/buttons.dart';
import 'package:orderbook_flutter/constant/constant.dart';

import '/../../../constant/my_domain.dart';
import '../api_call/orderPlace_api.dart';
import '../api_call/update_cart_api.dart';

class CartListScreen extends StatefulWidget {
  final String cartID;
  final String customerID;
  const CartListScreen(
      {Key? key, required this.cartID, required this.customerID})
      : super(key: key);

  @override
  State<CartListScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartListScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  List<dynamic> cartDetails = [];
  List<dynamic> productSubcategory = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartDetails();
  }

  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    return {'access': access};
  }

  Future<void> fetchCartDetails() async {
    final String productSubcategoryListApi =
        '${DomainName.domainName}api/order/cart/${widget.cartID}/';

    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];

    // print(productSubcategoryListApi);

    final http.Response response = await http.get(
      Uri.parse(productSubcategoryListApi),
      headers: {'Authorization': 'Bearer $getAccessToken'},
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      setState(() {
        print(decodedResponse);
        cartDetails = [
          {
            "id": decodedResponse['id'],
            "customer": decodedResponse['customer'],
            "customer_name": decodedResponse['customer_name'],
            "created_by": decodedResponse['created_by'],
          }
        ];
        productSubcategory = decodedResponse['cart_products'];
        print(cartDetails.first);
        print(productSubcategory.first);
        calculateTotalPrice();
      });
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  void calculateTotalPrice() {
    totalPrice = 0.0;
    for (final subproduct in productSubcategory) {
      totalPrice += (subproduct['price'] * subproduct['quantity']);
    }
  }


  void orderPlaceApi(BuildContext context, List productSubcategory, String customerID, List<int> idList, String cartID) {
    Apicall(
      context: context, 
      productSubcategory: productSubcategory, 
      customerID: customerID, 
      cartID:cartID,
      idList: idList).orderPlace();

    
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => updateCart(
          context, productSubcategory, widget.customerID, widget.cartID),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: const BackButton(),
          iconTheme: IconThemeData(color: white),
          title: Text(
            'Order List',
            style: TextStyle(color: white),
          ),
          centerTitle: true,
          backgroundColor: blue,
          automaticallyImplyLeading: false,
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: productSubcategory.isEmpty
                  ? const Center(
                      child: Text(
                        'Please Wait',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: productSubcategory.length,
                      itemBuilder: (BuildContext context, int index) {
                        final subproduct = productSubcategory[index];
                        return ListTile(
                          title: Text(subproduct['sub_products_name']),
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
                                      calculateTotalPrice();
                                    }
                                  });
                                },
                              ),
                              Container(
                                width: size.width / 40,
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
                                      calculateTotalPrice();
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    subproduct['quantity']++;
                                    calculateTotalPrice();
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Total:"),
                  Text('${totalPrice.toStringAsFixed(2)}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  CustomElevatedButton(
                    buttonstyle: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(blue)),
                    onPressed: () {
                      List<int> idList = [];
                      String customerID = cartDetails[0]['customer'].toString();
                      for (final subproduct in productSubcategory) {
                        int ID = subproduct['sub_product'];
                        idList.add(ID);
                      }
                      String cartID = widget.cartID;
                      orderPlaceApi(context, productSubcategory, customerID, idList,cartID);
                    },
                    buttonText: 'Place Order',
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                  SizedBox(width: size.width / 40),
                  CustomElevatedButton(
                    onPressed: () {
                      String customerId = widget.customerID;
                      GoRouter.of(context)
                          .push('/customer/customerProduct/$customerId');
                      updateCart(context, productSubcategory, widget.customerID,
                          widget.cartID);
                    },
                    buttonstyle: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(blue)),
                    buttonText: 'Add Products',
                    style: TextStyle(color: white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
