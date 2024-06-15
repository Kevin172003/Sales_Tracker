import 'package:flutter/material.dart';
import 'package:orderbook_flutter/componets/buttons.dart';
import 'package:orderbook_flutter/constant/constant.dart';

import '../api_call/newSubProduct_api.dart';

class Subcategory {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Subcategory();

  String get name => nameController.text;
  String get price => priceController.text;
}

class CreateNewSubcategory extends StatefulWidget {
  final Function onAddSubProduct;
  final String productId;

  CreateNewSubcategory(
      {Key? key, required this.onAddSubProduct, required this.productId})
      : super(key: key);

  @override
  CreateNewSubcategoryState createState() => CreateNewSubcategoryState();
}

class CreateNewSubcategoryState extends State<CreateNewSubcategory> {
  List<Subcategory> newSubcategories = [];
  bool isSubProductNameEmpty = false;

  @override
  void initState() {
    super.initState();
    newSubcategories.add(Subcategory());
  }

  @override
  void dispose() {
    for (var subcategory in newSubcategories) {
      subcategory.nameController.dispose();
      subcategory.priceController.dispose();
    }
    super.dispose();
  }

  void resetState() {
    setState(() {
      newSubcategories.clear();
      newSubcategories.add(Subcategory());
      isSubProductNameEmpty = false;
    });
  }

  void validateAndAddProduct(BuildContext context) async {
    setState(() {
      isSubProductNameEmpty = newSubcategories.any((subcategory) =>
      subcategory.nameController.text.isEmpty ||
          subcategory.priceController.text.isEmpty);
    });

    if (!isSubProductNameEmpty) {
      await addSubProduct(context, newSubcategories, widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Subcategory'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                for (int index = 0; index < newSubcategories.length; index++)
                  Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        newSubcategories.removeAt(index);
                      });
                    },
                    background: Container(
                      child: Icon(
                        Icons.delete,
                        color: blue,
                        size: 30,
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                    ),
                    child: buildSubcategoryRow(newSubcategories[index]),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        CustomTextButton(
          onPressed: () {
            setState(() {
              newSubcategories.add(Subcategory());
            });
          },
          buttonText: 'Add New',
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomTextButton(
              onPressed: () {
                resetState();
                Navigator.of(context).pop();
              },
              buttonText: 'Close',
            ),
            const SizedBox(width: 10),
            CustomTextButton(
              onPressed: () {
                validateAndAddProduct(context);
              },
              buttonText: 'Add',
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSubcategoryRow(Subcategory subcategory) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: subcategory.nameController,
            decoration: InputDecoration(
              labelText: 'Subcategory Name',
              labelStyle: TextStyle(
                color: subcategory.nameController.text.isEmpty &&
                    isSubProductNameEmpty
                    ? Colors.red
                    : Colors.black54,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: subcategory.priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              labelStyle: TextStyle(
                color: subcategory.priceController.text.isEmpty &&
                    isSubProductNameEmpty
                    ? Colors.red
                    : Colors.black54,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
