import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import '../../../../constant/my_domain.dart';
import 'package:http/http.dart' as http;
import '../../profile_screen/profilescreen.dart';
import 'customer_invoice.dart';

class DateRange {
  DateTime startDate;
  DateTime endDate;

  DateRange({required this.startDate, required this.endDate});
}

class CustomerOrderList extends StatefulWidget {
  final String vendorID;

  const CustomerOrderList({Key? key, required  this.vendorID}) : super(key: key);

  @override
  State<CustomerOrderList> createState() => _CustomerOrderListState();
}

class _CustomerOrderListState extends State<CustomerOrderList> {
  late DateTime _startDate;
  late DateTime _endDate;
  DateRange? selectedDateRange;
  List<dynamic> orderList = [];


  @override
  void initState() {
    super.initState();
    _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _endDate = DateTime.now();
    fetchOrderList();
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 30)), // 1 month ago
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = DateRange(
          startDate: picked.start,
          endDate: picked.end,
        );
      });
    }
  }

  String formatOrderDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat('yyyy-MM-dd H:mm');
    return formatter.format(dateTime);
  }




  Future<void> fetchOrderList() async {
    try {
      final String productListApi = '${DomainName.domainName}api/order/order/?vendor_id=${widget.vendorID}';
      final FlutterSecureStorage secureStorage = FlutterSecureStorage();
      print(productListApi);

      Future<Map<String, String?>> getAccessTokens() async {
        final String? access = await secureStorage.read(key: 'access');
        return {'access': access};
      }

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
          setState(() {
            orderList = decodedResponse['data'];
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: blue,
        iconTheme: IconThemeData(color: white),
        centerTitle: true,
        title: Text(
          "Order List",
          style: TextStyle(color: white),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: white,
            child: ClipOval(
              child: IconButton(
                onPressed: () {
                  GoRouter.of(context).push('/customervenorlist/customer-profile');
                },
                icon: Icon(
                  Icons.person,
                  color: blue,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: size.width / 50),
              Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Icon(Icons.date_range_outlined)),
                  Text(selectedDateRange == null
                      ? 'Select Date Range'
                      : 'Selected Date Range: ${selectedDateRange!.startDate.toString().substring(0, 10)} - ${selectedDateRange!.endDate.toString().substring(0, 10)}'),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                var orderId = orderList[index]['id'];
                var formattedDate =orderList[index]['order_date'];
                var orderDate = formatOrderDate(formattedDate);
                return GestureDetector(
                  onTap: () {

                    GoRouter.of(context).push('/customervenorlist/customer-vendor-orderist/${widget.vendorID}/invoice/$orderId');

                  },
                  child: Card(
                    child: ListTile(
                      title: Text(orderDate.toString()),
                      // subtitle: Text(orderId.toString()),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
