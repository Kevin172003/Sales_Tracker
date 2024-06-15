import 'package:flutter/material.dart';
import 'package:orderbook_flutter/componets/buttons.dart';

import '../api_calling/createCustomer_api.dart';


class AddCustomer extends StatefulWidget {
  final Function onAddCustomer;

  AddCustomer({Key? key,  required this.onAddCustomer}) : super(key: key);

  @override
  AddCustomerState createState() => AddCustomerState();
}

class AddCustomerState extends State<AddCustomer> {

  TextEditingController customerName= TextEditingController();
  TextEditingController customerNumber = TextEditingController();
  TextEditingController customerAddress= TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Customer'),
      content: Container(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: customerName,
                decoration: const InputDecoration(labelText: 'Customer Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: customerNumber,
                decoration: const InputDecoration(labelText: 'Contact Number'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: customerAddress,
                decoration: const InputDecoration(labelText: 'Adderss'),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  addCustomer(context,customerName,customerNumber,customerAddress);

                },
                buttonText: 'Add Customer',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
