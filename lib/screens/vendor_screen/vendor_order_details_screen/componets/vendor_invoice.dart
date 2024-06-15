import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:orderbook_flutter/constant/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

import '../../../../constant/my_domain.dart';

class VendorInvoiceScreen extends StatefulWidget {
  final String orderId;

  const VendorInvoiceScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  State<VendorInvoiceScreen> createState() => _VendorInvoiceScreenState();
}

class _VendorInvoiceScreenState extends State<VendorInvoiceScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  double grandTotal = 0.0;
  List<dynamic> orderData = [];
  List<dynamic> orderDataDetails = [];

  Future<Map<String, String?>> getAccessTokens() async {
    final String? access = await secureStorage.read(key: 'access');
    return {'access': access};
  }

  @override
  void initState() {
    super.initState();
    fetchInvoiceDetails();
  }

  double calculateTotal(double price, int quantity) {
    return price * quantity.toDouble();
  }

  void calculateGrandTotal() {
    grandTotal = 0.0;
    for (var item in orderDataDetails) {
      double? price = item['price']?.toDouble();
      int? quantity = item['quantity'];
      if (price != null && quantity != null) {
        grandTotal += calculateTotal(price, quantity);
      }
    }
  }

  String formatOrderDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat('yyyy-MM-dd H:mm');
    return formatter.format(dateTime);
  }

  Future<void> fetchInvoiceDetails() async {
    final String customerInvoiceListApi =
        '${DomainName.domainName}api/order/order/${widget.orderId}/';
    print(customerInvoiceListApi);
    final Map<String, String?> tokens = await getAccessTokens();
    final String? getAccessToken = tokens['access'];

    final http.Response response = await http.get(
      Uri.parse(customerInvoiceListApi),
      headers: {'Authorization': 'Bearer $getAccessToken'},
    );

    print("invoice response body ${response.body}");

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      print(decodedResponse);

      if (decodedResponse['status_code'] == 200) {
        setState(() {
          final orderid = decodedResponse['data']['id'];
          final customerName = decodedResponse['data']['customer_name'];
          final customerAddress = decodedResponse['data']['customer_address'];
          final formattedDate = decodedResponse['data']['order_date'];
          final productsDetails = decodedResponse['data']['products'];
          // final String formattedDate = orderData.isNotEmpty ? orderData[0]['order_date'] : '';
          final orderDate = formatOrderDate(formattedDate);
          orderData = [
            {
              'id': orderid,
              'customer_name': customerName,
              'customer_address': customerAddress,
              'order_date': orderDate,
            }
          ];
          orderDataDetails = productsDetails;
          calculateGrandTotal();
        });
      } else {
        print('API returned an error: ${decodedResponse['message']}');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  }

  Future<void> _downloadPDF(BuildContext context) async {
    // Check and request storage permission
    if (!(await Permission.storage.isGranted)) {
      await Permission.storage.request();

      if (!(await Permission.storage.isGranted)) {
        debugPrint("Permission is not granted");
        return;
      }
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Sales Report'),
              ],
            ),
          ),
          _buildInvoiceDetails(),
        ],
      ),
    );

    final pdfBytes = await pdf.save();

    final saveDirectory = await FilePicker.platform.getDirectoryPath();

    if (saveDirectory != null) {
      final outputFilePath = "$saveDirectory/invoice.pdf";
      final pdfFile = File(outputFilePath);

      try {
        await pdfFile.writeAsBytes(pdfBytes);
        debugPrint('PDF downloaded to: $outputFilePath');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invoice saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        debugPrint('Error writing PDF file: $e');
      }
    } else {
      debugPrint('No directory selected for downloading.');
    }

  }

  Future<void> _sharePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Sales Report'),
              ],
            ),
          ),
          _buildInvoiceDetails(),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/sales_report.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareFiles([file.path]);
  }

  pw.Column _buildInvoiceDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text('Sales Tracker'),
                pw.Text("Vendor Name"),
              ],
            )
          ],
        ),
        pw.Divider(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              children: [
                pw.Text(
                    "INVOICE TO :\n${orderData.isNotEmpty ? orderData[0]['customer_name'] : ''}"),
              ],
            ),
            pw.Column(
              children: [
                pw.Text(
                  "# Order Id : ${widget.orderId}",
                  style: const pw.TextStyle(fontSize: 30),
                ),
                pw.Text(orderData.isNotEmpty ? orderData[0]['order_date'] : ''),
              ],
            ),
          ],
        ),
        pw.Divider(height: 20),
        pw.Column(
          children: [
            pw.Container(
              color: PdfColors.blue,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        "No",
                        style: const pw.TextStyle(
                            fontSize: 16.0, color: PdfColors.white),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        "Name",
                        style: const pw.TextStyle(
                            fontSize: 16.0, color: PdfColors.white),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        "Quantity",
                        style: const pw.TextStyle(
                            fontSize: 16.0, color: PdfColors.white),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        "Price",
                        style: const pw.TextStyle(
                            fontSize: 16.0, color: PdfColors.white),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(
                        "Total",
                        style: const pw.TextStyle(
                            fontSize: 16.0, color: PdfColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.ListView.builder(
              itemCount: orderDataDetails.length,
              itemBuilder: (context, index) {
                var name = orderDataDetails[index]['sub_products_name'];
                var quantity = orderDataDetails[index]['quantity'];
                var price = orderDataDetails[index]['price'];
                final total = price * quantity;
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          (index + 1).toString(),
                          style: const pw.TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          name,
                          style: const pw.TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          quantity.toString(),
                          style: const pw.TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          price.toString(),
                          style: const pw.TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          total.toString(),
                          style: const pw.TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(265, 0, 0, 0),
          child: pw.Text('Total: ${grandTotal.toStringAsFixed(2)}'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // final String formattedDate = orderData.isNotEmpty ? orderData[0]['order_date'] : '';
    // final String orderDate = formatOrderDate(formattedDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Your Invoice',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/Image/logo.png',
                          height: 70,
                          width: 70,
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Sales Tracker'),
                            Text("Vendor Name"),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      height: size.height * 0.1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                                "INVOICE TO :\n${orderData.isNotEmpty ? orderData[0]['customer_name'] : ''}"),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "# Order Id : ${widget.orderId}",
                              style: const TextStyle(fontSize: 30),
                            ),
                            Text(
                              orderData.isNotEmpty
                                  ? orderData[0]['order_date']
                                  : '',
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      height: size.height * 0.1,
                    ),
                    Column(
                      children: [
                        Container(
                          color: blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "No",
                                    style:
                                        TextStyle(fontSize: 16.0, color: white),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Name",
                                    style:
                                        TextStyle(fontSize: 16.0, color: white),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Quantity",
                                    style:
                                        TextStyle(fontSize: 16.0, color: white),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Price",
                                    style:
                                        TextStyle(fontSize: 16.0, color: white),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Total",
                                    style:
                                        TextStyle(fontSize: 16.0, color: white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderDataDetails.length,
                          itemBuilder: (context, index) {
                            var subProduct_id =
                                orderDataDetails[index]['sub_product'];
                            var name =
                                orderDataDetails[index]['sub_products_name'];
                            var quantity = orderDataDetails[index]['quantity'];
                            var price = orderDataDetails[index]['price'];
                            final total = price * quantity;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      name,
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      price.toString(),
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      total.toString(),
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.009),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(265, 0, 0, 0),
                      child: Text('Total: ${grandTotal.toStringAsFixed(2)}'),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            _sharePDF();
                          },
                          icon: const Icon(Icons.share),
                        ),
                        SizedBox(width: size.width * 0.01),
                        // IconButton(
                        //   onPressed: () {
                        //     _downloadPDF(context);
                        //   },
                        //   icon: const Icon(Icons.download),
                        // ),
                      ],
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
