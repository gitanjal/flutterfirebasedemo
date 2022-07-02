import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController _controllerName=TextEditingController();
  TextEditingController _controllerQuantity=TextEditingController();

  GlobalKey<FormState> key=GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add an item'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration: InputDecoration(
                  hintText: 'Enter the name of the item'
                ),
                validator: (String? value){

                  if(value==null || value.isEmpty)
                    {
                      return 'Please enter the item name';
                    }

                  return null;
                },
              ),
              TextFormField(
                controller: _controllerQuantity,
                decoration: InputDecoration(
                    hintText: 'Enter the quantity of the item'
                ),
                validator: (String? value){

                  if(value==null || value.isEmpty)
                  {
                    return 'Please enter the item quantity';
                  }

                  return null;
                },
              ),
              ElevatedButton(onPressed: () async{

                if(key.currentState!.validate())
                  {
                    //Create a Map with the input data
                    Map<String,String> dataToSave={
                      'name':_controllerName.text,
                      'quantity':_controllerQuantity.text
                    };

                    //Add the data to the database
                    CollectionReference reference=FirebaseFirestore.instance.collection('shopping_list');
                    try {
                      await reference.add(dataToSave);

                      if(!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added successfully')));
                    }catch (error)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some error occurred $error')));
                    }
                  }



              }, child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
