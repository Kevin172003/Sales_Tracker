import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '/../../../constant/constant.dart';
import '/../../../constant/my_domain.dart';

class OrderCustomerList extends StatefulWidget {
  const OrderCustomerList({super.key});

  @override
  State<OrderCustomerList> createState() => _OrderCustomerListState();
}

class _OrderCustomerListState extends State<OrderCustomerList> {
  final String customerListApi = '${DomainName.domainName}api/order/cart/';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  List<dynamic> customerList = [];
  int _animatedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchCustomerList();
  }

  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    return {'access': access};
  }

  Future<void> fetchCustomerList() async {
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];

    final http.Response response = await http.get(
      Uri.parse(customerListApi),
      headers: {
        'Authorization': 'Bearer $getAccessToken',
        'Content-Type': 'application/json'
      },
    );
    log("Response body status : ${response.statusCode}");

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['status_code'] == 200) {
        final List<dynamic> customerListData = decodedResponse['data'];
        setState(() {
          customerList = customerListData;
          // print(decodedResponse);
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
    return customerList.isEmpty
        ? Center(child: Text('No cart found'))
        : SingleChildScrollView(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: ListView.builder(
                itemCount: customerList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      String cartId = customerList[index]['id'].toString();
                      String customerId =
                          customerList[index]['customer'].toString();

                      setState(() {
                        _animatedIndex = index;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) {
                          setState(() {
                            _animatedIndex = -1;
                          });
                        }
                        // Navigate to the next screen after the animation
                        GoRouter.of(context)
                            .push('/cart/catlist/$customerId/$cartId');
                      });
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> CartListScreen(cartID:cartID,customerID:customerID)));
                    },
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          color:
                              _animatedIndex == index ? white : backgroundColor,
                          child: ListTile(
                            title: Text(
                              customerList[index]['customer_name'],
                              style: TextStyle(
                                color: black,
                              ),
                            ),
                            subtitle: Text(
                              customerList[index]['customer_address'],
                              style: TextStyle(color: black),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width / 1,
                          height: size.height * 0.0002,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }
}
