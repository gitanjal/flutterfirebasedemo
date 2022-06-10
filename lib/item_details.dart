import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return Scaffold(
        appBar: AppBar(title: Text('Item details'),),
        body: FutureBuilder<DocumentSnapshot>(
          future: _futureDocument,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Some error occurred ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot = snapshot.data;
              Map<String, dynamic> mapData = documentSnapshot.data() as Map<
                  String,
                  dynamic>;

              return Column(
                children: [Text(mapData['name']),Text(mapData['quantity']),],
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        )

    );
  }
}
