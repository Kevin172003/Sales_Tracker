import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:orderbook_flutter/constant/my_domain.dart';

import 'customer_order_list.dart';

class CustomerVendorList extends StatefulWidget {
  const CustomerVendorList({super.key});

  @override
  State<CustomerVendorList> createState() => _CustomerVendorListState();
}

class _CustomerVendorListState extends State<CustomerVendorList> {
  final String customerListApi = '${DomainName.domainName}api/users/vendor/';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  List<dynamic> customerVendorList = [];

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
    log(response.statusCode);

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['status_code'] == 200) {
        print(decodedResponse);
        setState(() {
          customerVendorList = decodedResponse['data'];
          print(customerVendorList);
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: customerVendorList.length,
                itemBuilder: (context, index) {
                  var vendorID = customerVendorList[index]['id'];
                  var fName =
                      customerVendorList[index]['first_name'].toString();
                  var address = customerVendorList[index]['address'].toString();

                  return GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push('/customervenorlist/customer-vendor-orderist/$vendorID');


                    },
                    child: Card(
                      child: ListTile(
                        title: Text(fName),
                        subtitle: Text(
                          address,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
