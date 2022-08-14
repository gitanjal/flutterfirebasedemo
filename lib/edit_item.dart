import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditItem extends StatefulWidget {
  Map<String,dynamic> shoppingItem;
  EditItem(this.shoppingItem,{Key? key}) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  late TextEditingController _controllerName ;
  late TextEditingController _controllerQuantity ;
  GlobalKey<FormState> key = GlobalKey();

  initState(){
    super.initState();
    _controllerName =
        TextEditingController(text: widget.shoppingItem['name']);
    _controllerQuantity =
        TextEditingController(text: widget.shoppingItem['quantity']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
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
                    if (key.currentState!.validate()) {

                      //Create a Map with the input data
                      Map<String,String> dataToUpdate={
                        'name':_controllerName.text,
                        'quantity':_controllerQuantity.text,
                      };

                      //Add the data to the database
                      CollectionReference collection=FirebaseFirestore.instance.collection('shopping_list');
                      DocumentReference document=collection.doc(widget.shoppingItem['doc_id']);
                      document.update(dataToUpdate);

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
