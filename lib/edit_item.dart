import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditItem extends StatelessWidget {
  EditItem(this._shoppingItem, {Key? key}) {
    _controllerName = TextEditingController(text: _shoppingItem['name']);
    _controllerQuantity =
        TextEditingController(text: _shoppingItem['quantity']);

    _reference = FirebaseFirestore.instance
        .collection('shopping_list')
        .doc(_shoppingItem['id']);
  }

  Map _shoppingItem;
  late DocumentReference _reference;

  late TextEditingController _controllerName;
  late TextEditingController _controllerQuantity;
  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration:
                    InputDecoration(hintText: 'Enter the name of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _controllerQuantity,
                decoration:
                    InputDecoration(hintText: 'Enter the quantity of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item quantity';
                  }

                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      String name = _controllerName.text;
                      String quantity = _controllerQuantity.text;

                      //Create the Map of data
                      Map<String,String> dataToUpdate={
                        'name':name,
                        'quantity':quantity
                      };

                      //Call update()
                      _reference.update(dataToUpdate);
                    }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
