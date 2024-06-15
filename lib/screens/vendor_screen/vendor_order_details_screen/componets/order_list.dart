import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:orderbook_flutter/constant/constant.dart';
import '../../../../constant/my_domain.dart';
import 'orderlist_searchbar.dart';


class VendorOrderList extends StatefulWidget {
  const VendorOrderList({super.key});

  @override
  State<VendorOrderList> createState() => _VendorOrderListState();
}

class _VendorOrderListState extends State<VendorOrderList> {
  List<dynamic> orderList = [];
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<Map<String, String?>> getAccessTokens() async {
        final String? access = await secureStorage.read(key: 'access');
        return {'access': access};
      }

  @override
  void initState() {
    super.initState();
    fetchOrderList();
  }

  Future<void> fetchOrderList() async {
    try {
      final String productListApi = '${DomainName.domainName}api/order/order/';

      final Map<String, String?> tokens = await getAccessTokens();
      final String? getAccessToken = tokens['access'];

      final http.Response response = await http.get(
        Uri.parse(productListApi),
        headers: {
          'Authorization': 'Bearer $getAccessToken',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        print(decodedResponse);
        if (decodedResponse['status_code'] == 200) {
          final List<dynamic> orders = decodedResponse['data'];
          setState(() {
            orderList = orders;
            print(orderList);
          });
        } else {
          print('API returned an error: ${decodedResponse['message']}');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

    Future<void> deleteOrder(String orderId) async {
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];
    final String apiDelete =
        "${DomainName.domainName}api/order/order/$orderId/";

        print(apiDelete);
    try {
      final response = await http.delete(
        Uri.parse(apiDelete),
        headers: {'Authorization': 'Bearer $getAccessToken'},
      );
      if (response.statusCode == 200) {
        print("===========");
        setState(() {
          orderList.removeWhere((order) => order['id'].toString() == orderId);
        });
        if (orderList.isEmpty) {
          setState(() {});
        } else {
          fetchOrderList();
        }
      } else {
        print('Failed to delete order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting order: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        const VendorOrderSearchBar(),
        SizedBox(height: size.height / 160),

        Container(
          width: double.maxFinite,
          height: 0.1,
          color: Colors.black,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              var order = orderList[index];
              var orderId= order['id'].toString();
              var customerName = order['customer_name'] ?? '';
              var customerAddress = order['customer_address'] ?? '';

              return GestureDetector(
                onTap: () {
                  GoRouter.of(context).push('/vendororder/orderinvoice/$orderId');
                },
                child: Column(
                  children: [
                    Slidable(
                      endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      deleteOrder(orderId);
        
                                    },
                                    // backgroundColor:blue,
                                    foregroundColor:blue,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              
                      child: Card(
                        child: ListTile(
                          title: Text(customerName),
                          subtitle: Text(customerAddress),
                        ),
                                    
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
