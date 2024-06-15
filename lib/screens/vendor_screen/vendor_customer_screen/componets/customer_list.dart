import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../../constant/my_domain.dart';
import '../api_calling/get_customer_api.dart';
import 'searchbar_screen.dart';

class CustomerListView extends StatefulWidget {
  const CustomerListView({super.key});

  @override
  State<CustomerListView> createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<CustomerListView> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  List<GetCustomerApi> apiList = [];
  bool showArchivedCustomers = false;
  int _animatedIndex = -1;

  final String url = "${DomainName.domainName}api/users/customer/";
  final TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  void initState() {
    super.initState();
    getCusomerList();
  }

  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    return {'access': access};
  }

  Future<void> getCusomerList() async {
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];

    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $getAccessToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['data'] is List) {
        final List<dynamic> dataList = jsonData['data'];
        setState(() {

          apiList = dataList
              .map((item) => GetCustomerApi.fromJson(item))
              .toList()
              .cast<GetCustomerApi>();
        });
        print(dataList);
      } else {
        print("Invalid data format: jsonData['data'] is not a List");
        // Handle this case according to your application's logic
      }

      // setState(() {
      //   final List<dynamic> dataList = jsonData['data'];
      //   apiList = dataList
      //       .map((item) => GetCustomerApi.fromJson(item))
      //       .toList()
      //       .cast<GetCustomerApi>();
      // });
    } else {
      print("Failed to load data: ${response.statusCode}");
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];
    final String apiDelete =
        "${DomainName.domainName}api/users/customer/$customerId/";
    try {
      final response = await http.delete(
        Uri.parse(apiDelete),
        headers: {'Authorization': 'Bearer $getAccessToken'},
      );
      if (response.statusCode == 200) {
        setState(() {
          apiList.removeWhere((customer) => customer.id.toString() == customerId);
        });
        if (apiList.isEmpty) {
          setState(() {});
        } else {
          getCusomerList();
        }
      } else {
        print('Failed to delete customer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting customer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        CustomerSearchBar(
          searchController: searchController,
          onSearchChanged: (String? value) {
            setState(() {
              search = value ?? "";
            });
          },
        ),
        SizedBox(
          height: size.height / 160,
        ),
        Container(
          width: double.infinity,
          height: 0.1,
          color: Colors.black,
        ),
        Expanded(
          child: apiList.isEmpty
              ? const Center(child: Text('Add Customers'))
              : ListView.builder(
                  itemCount: apiList.length,
                  itemBuilder: (context, index) {
                    final customer = apiList[index];
                    final customerId = customer.id.toString();
                    final searchQuery = searchController.text.toLowerCase();
                    final nameMatches =
                        customer.name!.toLowerCase().contains(searchQuery);
                    final addressMatches =
                        customer.address!.toLowerCase().contains(searchQuery);
                    if (searchQuery.isEmpty || nameMatches || addressMatches) {
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
                            GoRouter.of(context)
                                .go('/customer/customerProduct/$customerId');
                          });
                        },
                        child: Column(
                          children: [
                            Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      deleteCustomer(customerId);
                                    },
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                color: _animatedIndex == index
                                    ? Colors.white
                                    : Colors.grey.shade200,
                                child: ListTile(
                                  tileColor: Colors.grey.shade200,
                                  title: Text(
                                    customer.name ?? 'No Name',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    customer.address ?? 'No Address',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 0.1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
        ),
      ],
    );
  }
}
