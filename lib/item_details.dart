import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_item.dart';

class ItemDetails extends StatelessWidget {
 late DocumentReference _documentReference;
  late Future<DocumentSnapshot> _futureDocument;

  ItemDetails(String id, {Key? key}) : super(key: key) {
     _documentReference =
        FirebaseFirestore.instance.collection('shopping_list').doc(id);
    _futureDocument = _documentReference.get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _futureDocument,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return buildWidgetTree(context,
              Center(child: Text('Some error occurred ${snapshot.error}')));
        }

        if (snapshot.hasData) {
          DocumentSnapshot documentSnapshot = snapshot.data;
          Map<String, dynamic> mapData =
              documentSnapshot.data() as Map<String, dynamic>;
          mapData['doc_id'] = documentSnapshot.id;

          return buildWidgetTree(
              context,
              Column(
                children: [
                  Text(mapData['name']),
                  Text(mapData['quantity']),
                ],
              ),
              data: mapData);
        }

        return buildWidgetTree(
            context, Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget buildWidgetTree(BuildContext context, Widget widgetBody,
      {Map<String, dynamic> data = const {}}) {
    return Scaffold(
      appBar: AppBar(title: Text('Item details'), actions: [
        data.isEmpty
            ? Container()
            : IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditItem(data),
                  ));
                },
              ),
        IconButton(onPressed: (){
          //delete the document
          _documentReference.delete();
        }, icon: Icon(Icons.delete)),
      ]),
      body: widgetBody,
    );
  }
}
